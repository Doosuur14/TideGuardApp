//
//  ReportViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 09.06.2025.
//

import UIKit

class ReportViewController: UIViewController, ReportDelegate {


    let viewModel: ReportViewModel
    var reportView: ReportView?
    //var reportView: ReportView

    init(viewModel: ReportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        checkAndRequestNotificationPermission()
        setupGesture()

    }

    private func setUpView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Report An Emergency!"
        reportView = ReportView(frame: view.bounds)
        view.addSubview(reportView ?? UIView())
        reportView?.snp.makeConstraints { make in make.edges.equalToSuperview() }
        reportView?.delegate = self
        reportView?.backgroundColor = .systemBackground

    }

    func didUploadReport(image: UIImage?, description: String) {
        let severity = reportView?.selectedSeverity ?? "minor"
        viewModel.uploadReport(image: image, description: description, severity: severity) { [weak self] result in
            switch result {
            case .success:
                self?.reportView?.descriptionTextView.text = "" 
                self?.reportView?.imageView.image = nil
                self?.reportView?.imageDidChange(false)
                self?.reportView?.selectSeverity("minor")
            case .failure(_):
                AlertManager.shared.showUpdateFailureAlert(viewCon: self ?? UIViewController())
            }
        }
    }


    private func checkAndRequestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if let error = error {
                        print("Notification permission error: \(error)")
                    }
                    self?.handlePermissionResult(granted)
                }
            } else {
                self?.handlePermissionResult(settings.authorizationStatus == .authorized)
            }
        }
    }

    private func handlePermissionResult(_ granted: Bool) {
        DispatchQueue.main.async { [weak self] in
            if granted {
                print("Notifications authorized")
            } else {
                print("Notifications not authorized")
                let alert = UIAlertController(title: "Notifications Disabled", message: "Please enable notifications in Settings to receive updates.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }


    func setupGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTaponAvatar))
        reportView?.imageView.addGestureRecognizer(tapGestureRecognizer)
    }


    @objc func didTaponAvatar() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
}


extension ReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        if let image = info[.originalImage] as? UIImage {
//            reportView?.imageView.image = image
//            reportView?.imageDidChange(true)
//        }
//        picker.dismiss(animated: true)
//    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        picker.dismiss(animated: true)

        reportView?.uploadButton.setTitle("Analysing image...", for: .normal)
        reportView?.uploadButton.isEnabled = false

        FloodImageClassifier.shared.classify(image: image) { [weak self] isFlood, confidence, severity in
            DispatchQueue.main.async {

                self?.reportView?.uploadButton.setTitle("Submit Report", for: .normal)
                self?.reportView?.uploadButton.isEnabled = true

                if isFlood {
                    self?.reportView?.imageView.image = image
                    self?.reportView?.imageDidChange(true)
                    self?.reportView?.selectSeverity(severity)
                    self?.showFloodConfirmedBanner(confidence: confidence, severity: severity)
                } else {

                    self?.showNotFloodAlert(confidence: confidence)
                }
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }


    private func showNotFloodAlert(confidence: Float) {
        let percentage = Int(confidence * 100)
        let alert = UIAlertController(
            title: "Not a Flood Image",
            message: "Our classifier is \(percentage)% confident this photo doesn't show a flood. Please upload a photo of the flooded area.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Try Again", style: .default))
        present(alert, animated: true)
    }

    private func showFloodConfirmedBanner(confidence: Float,severity: String) {
        let percentage = Int(confidence * 100)
        let severityLabel = severity == "severe" ? "🔴 Severe"
        : severity == "moderate" ? "🟠 Moderate"
        : "🟡 Minor"

        let banner = UILabel()
        banner.text = "Flood image confirmed (\(percentage)% confidence)"
        banner.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        banner.textColor = .white
        banner.textAlignment = .center
        banner.backgroundColor = UIColor.systemGreen
        banner.layer.cornerRadius = 10
        banner.clipsToBounds = true
        banner.alpha = 0

        view.addSubview(banner)
        banner.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        UIView.animate(withDuration: 0.3, animations: {
            banner.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2.5) {
                banner.alpha = 0
            } completion: { _ in
                banner.removeFromSuperview()
            }
        }
    }
}

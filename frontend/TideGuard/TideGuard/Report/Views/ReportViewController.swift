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
//        view = reportView
        view.addSubview(reportView ?? UIView())
        reportView?.snp.makeConstraints { make in make.edges.equalToSuperview() }
        reportView?.delegate = self
        reportView?.backgroundColor = .systemBackground

    }

    func didUploadReport(image: UIImage?, description: String) {
        viewModel.uploadReport(image: image, description: description) { [weak self] result in
            switch result {
            case .success:
//                AlertManager.shared.showSuccessfulReportAlert(viewCon: self ?? UIViewController())
                self?.reportView?.descriptionTextView.text = "" 
                self?.reportView?.imageView.image = nil
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            reportView?.imageView.image = image
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

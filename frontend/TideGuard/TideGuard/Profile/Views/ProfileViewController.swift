//
//  ProfileViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 08.05.2025.
//

import UIKit
import Combine

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileViewDelegate {


    var profileView: ProfileView?
    let viewModel: ProfileViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGesture()
        setupBindings()
        viewModel.onProfileUpdated = { [weak self] in
            self?.profileView?.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserProfile()
    }

    private func setupView() {
        profileView = ProfileView(frame: view.bounds)
        profileView?.delegate = self
        profileView?.setupDelegate(with: self)
        profileView?.setupDataSource(with: self)
        profileView?.tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.profileReuseIdentifier)
        profileView?.tableView.separatorStyle = .none
        view = profileView
        view.backgroundColor = .systemBackground
    }

    private func setupBindings() {
        viewModel.$profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userProfile in
                self?.profileView?.firstName.text = userProfile?.firstName
                self?.profileView?.lastName.text = userProfile?.lastName
                self?.profileView?.userEmail.text = userProfile?.email
            }
            .store(in: &cancellables)
        viewModel.$profileImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newImage in
                self?.profileView?.avatarImage.image = newImage
                self?.profileView?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 3
        default: return 0
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let pviewModel = EditProfileViewModel()
            let viewCon = EditProfileViewController(viewModel: pviewModel)
            self.navigationController?.pushViewController(viewCon, animated: true)
        case (1, 0):
            viewModel.toggleTheme()
            profileView?.tableView.reloadData()
        case (2, 0):
            let fviewModel = FAQViewModel()
            let viewCon = FAQViewController(viewModel: fviewModel)
            self.navigationController?.pushViewController(viewCon, animated: true)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Account Information"
        case 1:
            return "Settings"
        case 2:
            return "Support"
        default:
            return nil
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func setupGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTaponAvatar))
        profileView?.avatarImage.addGestureRecognizer(tapGestureRecognizer)
    }

    
    @objc func didTaponAvatar() {

        UIView.animate(withDuration: 0.3) {
            self.profileView?.avatarImage.transform = CGAffineTransform(rotationAngle: .pi / 18) 
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.profileView?.avatarImage.transform = .identity
            }
        }

        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }


    func didPressLogoutButton() {
        viewModel.logOut { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let appCoordinator = AppCoordinator(navigationController: self.navigationController ?? UINavigationController())
                appCoordinator.start()
            case .failure(let error):
                print("Failed to log out: \(error)")
                let alert = UIAlertController(title: "Error", message: "Failed to log out: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    

    func didPressDeleteButton() {
        viewModel.deleteAccount { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let appCoordinator = AppCoordinator(navigationController: self.navigationController ?? UINavigationController())
                appCoordinator.start()
            case .failure(let error):
                print("Failed to delete account: \(error)")
                let alert = UIAlertController(title: "Error", message: "Failed to delete account: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicker = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileView?.avatarImage.image = imagePicker
            uploadSelectedImage(imagePicker)
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileView?.avatarImage.image = imageOriginal
            uploadSelectedImage(imageOriginal)
        }
        picker.dismiss(animated: true, completion: nil)
    }


    private func uploadSelectedImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            let alert = UIAlertController(title: "Error", message: "Failed to compress image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }

        let maxSize = 1 * 1024 * 1024
        if imageData.count > maxSize {
            let alert = UIAlertController(title: "Image Too Large", message: "The image exceeds the maximum size of 1 MB. Please select a smaller image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return
        }
        viewModel.uploadProfilePhoto(image) { result in
            switch result {
            case .success(_):
                let alert = UIAlertController(title: "Upload Sucessful", message: "Image upload was successful", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Upload Failed", message: "Image upload was not successful", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Upload Failed", message: "Please check your internet connection and try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

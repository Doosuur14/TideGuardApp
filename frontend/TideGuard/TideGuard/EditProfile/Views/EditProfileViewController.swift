//
//  EditProfileViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 05.06.2025.
//

import UIKit
import Combine

protocol EditProfileModuleProtocol: AnyObject {
    var editProfileView: EditProfileView? { get set }
    var viewModel: EditProfileViewModel { get }
}

class EditProfileViewController: UIViewController, EditProfileDelegate, EditProfileModuleProtocol {

    var editProfileView: EditProfileView?
    var viewModel: EditProfileViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel:EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.fetchUserProfile()
        viewModel.onProfileDetails = { [weak self] in
            self?.bindViewModel()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchUserProfile()
    }

    private func bindViewModel() {
        viewModel.$profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userProfile in
                self?.editProfileView?.firstName.text = userProfile?.firstName
                self?.editProfileView?.lastName.text = userProfile?.lastName
                self?.editProfileView?.email.text = userProfile?.email
                self?.editProfileView?.password.text = userProfile?.password
                self?.editProfileView?.cityTextField.text = userProfile?.city
            }
            .store(in: &cancellables)
    }


    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }


    func didTapSaveButton() {
        guard let form = editProfileView?.configureForm() else {
            AlertManager.shared.showEmptyFieldAlert(viewCon: self)
            return
        }
        guard isValidEmail(form.emailText ?? "") else {
            AlertManager.shared.showWrongEmailAlert(viewCon: self)
            return
        }


        viewModel.firstName = form.firstname ?? ""
        viewModel.lastName = form.lastname ?? ""
        viewModel.city = form.city ?? ""
        viewModel.email = form.emailText ?? ""


        guard !viewModel.firstName.isEmpty,
              !viewModel.lastName.isEmpty,
              !viewModel.city.isEmpty else {
            AlertManager.shared.showEmptyFieldAlert(viewCon: self)
            return
        }

        viewModel.updateUserProfile { [weak self] result in
            switch result {
            case .success(let updatedProfile):
                print("✅ Profile updated successfully: \(updatedProfile)")
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("❌ Failed to update profile: \(error)")
                AlertManager.shared.showUpdateFailureAlert(viewCon: self ?? UIViewController())
            }
        }

    }

    func didCancel() {
        navigationController?.popViewController(animated: true)
    }

    func setupView() {
        editProfileView = EditProfileView(frame: view.bounds)
        view = editProfileView
        editProfileView?.delegate = self
        editProfileView?.backgroundColor = .systemBackground

    }

}

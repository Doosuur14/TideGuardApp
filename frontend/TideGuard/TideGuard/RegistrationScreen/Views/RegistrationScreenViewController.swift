//
//  RegistrationScreenViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 07.04.2025.
//

import UIKit
import Combine

class RegistrationScreenViewController<ViewModel:
                                            RegistrationViewModelProtocol>: UIViewController, RegistrationDelegate {

    var registrationView: RegistrationScreenView?
    let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configureIO()
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        registrationView = RegistrationScreenView(frame: view.bounds)
        view = registrationView
        registrationView?.delegate = self
        view.backgroundColor = .systemBackground
    }

    private func configureIO() {
        viewModel.stateDidChangeForReg.receive(on: DispatchQueue.main)
            .sink { [weak self]  in
                self?.render()
            }
            .store(in: &cancellables)
    }

    private func render() {
        switch viewModel.state {
        case.initial:
            print("Application is running")
        case.isregisteredSuccessfully:
            AlertManager.shared.showRegistrationSuccessful(viewCon: self)
        case .registrationFailed:
            AlertManager.shared.showRegistrationFailedAlert(viewCon: self)
            break
        }
    }

    func didPressRegButton() {
        print("button was pressed")
        guard let form = registrationView?.configureSignUpForm() else {
            AlertManager.shared.showEmptyFieldAlert(viewCon: self)
            return
        }
        viewModel.register(.didTapRegisterButton, firstName: form.firstname ?? "",
                           lastName: form.lastname ?? "",
                           email: form.emailText ?? "",
                           password: form.passwordText ?? "", city: form.cityText ?? "")
    }

    func didPressAlreadyRegisteredButton() {
        viewModel.goToLoginController()
    }
}

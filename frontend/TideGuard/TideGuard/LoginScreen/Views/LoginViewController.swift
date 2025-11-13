//
//  LoginViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 31.03.2025.
//

import UIKit
import Combine

class LoginViewController<ViewModel: LoginMainViewModelProtocol>: UIViewController, LoginViewDelegate {

    var loginView: LoginScreenView?
    let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
  }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configureIO()
    }

    private func setUpView() {
        loginView = LoginScreenView(frame: view.bounds)
        view = loginView
        loginView?.delegate = self
        view.backgroundColor = .systemBackground
    }

    private func configureIO() {
        viewModel.stateDidChangeForLog.receive(on: DispatchQueue.main)
            .sink { [weak self]  in
                self?.render()
            }
            .store(in: &cancellables)
    }

    private func render() {
        switch viewModel.state {
        case .loading:
            print("loading state")
        case .isloggedSuccessfully:
            AlertManager.shared.showLoginAlert(viewCon: self)
        case .loginFailed:
            AlertManager.shared.showLoginErrorAlert(viewCon: self)
        }
    }


    func didPressLoginButton() {
        guard let form = loginView?.configureSignInForm() else {
            AlertManager.shared.showEmptyFieldAlert(viewCon: self)
            return
        }
        viewModel.trigger(.didTapLoginButton, email: form.0 ?? "", password: form.1 ?? "")
    }
}

//
//  SplashViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 05.04.2025.
//

import UIKit

class SplashViewController: UIViewController {

    var splashView: SplashView?
    let animationDuration: TimeInterval = 5.0
    private let viewModel: ViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        splashView?.onAnimationComplete = { [weak self] in
            self?.transitionToLogin()
        }
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        splashView = SplashView(frame: view.bounds)
        view = splashView
       // splashView?.backgroundColor = UIColor(red: 230/255, green: 240/255, blue: 250/255, alpha: 1)
    }

    func transitionToLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
//            let registeVC = RegistrationScreenViewController(viewModel: <#T##RegistrationViewModelProtocol#>)
//            registeVC.modalPresentationStyle = .fullScreen
//            self.present(loginVC, animated: true, completion: nil)
            self.viewModel.delegate?.goToReg()
        }
    }

}

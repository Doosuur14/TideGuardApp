//
//  LoginScreenView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 31.03.2025.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func didPressLoginButton()
}

final class LoginScreenView: UIView {

    lazy var appName: UILabel = UILabel()
    lazy var email: UITextField = UITextField()
    lazy var password: UITextField = UITextField()
    lazy var login: UIButton = UIButton()
    lazy var redirect: UILabel = UILabel()
    lazy var continueWithGoogle: UIButton = UIButton()
    lazy var termsAndConditions: UILabel = UILabel()
    lazy var conditions: UILabel = UILabel()
    lazy var googleImage: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFunctions()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: LoginViewDelegate?

    private func setUpFunctions() {
        setUpAppname()
        setupEmail()
        setupPassword()
        setupLoginButton()
        setupRedirect()
        setupGoogle()
        setupGoogleImage()
        setupTerms()
        setupConditions()
        addTapGestureToDismissKeyboard()
    }

    private func setUpAppname() {
        addSubview(appName)
        appName.text = "TideGuard"
        appName.textColor = UIColor(named: "MainColor")
        appName.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        appName.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupEmail() {
        addSubview(email)
        email.placeholder = "Email"
        email.backgroundColor = .clear
        email.borderStyle = .roundedRect
        email.autocapitalizationType = .none
        email.textColor = UIColor(named: "SubtitleColor")
        email.font = UIFont.systemFont(ofSize: 16)
        email.snp.makeConstraints { make in
            make.top.equalTo(appName.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setupPassword() {
        addSubview(password)
        password.placeholder = "Password"
        password.backgroundColor = .clear
        password.textContentType = .password
        password.isSecureTextEntry = true
        password.borderStyle = .roundedRect
        password.textColor = UIColor(named: "SubtitleColor")
        password.font = UIFont.systemFont(ofSize: 16)
        password.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setupLoginButton() {
        addSubview(login)
        login.setTitle("Login", for: .normal)
        login.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        login.isEnabled = true
        login.backgroundColor = UIColor(named: "MainColor")
        let action = UIAction { [weak self] _ in
            self?.delegate?.didPressLoginButton()
        }
        login.addAction(action, for: .touchUpInside)
        login.clipsToBounds = true
        login.layer.cornerRadius = 10
        login.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setupRedirect() {
        addSubview(redirect)
        redirect.text = "or"
        redirect.textColor = UIColor(named: "SubtitleColor")
        redirect.font = UIFont.systemFont(ofSize: 15, weight: .light)
        redirect.snp.makeConstraints { make in
            make.top.equalTo(login.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }

    private func setupGoogle() {
        addSubview(continueWithGoogle)
        continueWithGoogle.setTitle("Continue With Google", for: .normal)
        continueWithGoogle.setTitleColor(.subtitle, for: .normal)
        continueWithGoogle.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        continueWithGoogle.isEnabled = true
        continueWithGoogle.backgroundColor = UIColor(named: "Color")
        continueWithGoogle.clipsToBounds = true
        continueWithGoogle.layer.cornerRadius = 10
        continueWithGoogle.snp.makeConstraints { make in
            make.top.equalTo(redirect.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }


    private func setupTerms() {
        addSubview(termsAndConditions)
        termsAndConditions.text = "By continuing, you agree to TideGuard’s"
        termsAndConditions.textColor = UIColor(named: "SubtitileColor")
        termsAndConditions.font = UIFont.systemFont(ofSize: 10, weight: .light)
        termsAndConditions.snp.makeConstraints { make in
            make.top.equalTo(continueWithGoogle.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
    }

    private func setupConditions() {
        addSubview(conditions)

        let attributedString = NSMutableAttributedString(string: "Terms of Service and Privacy Policy")
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        conditions.attributedText = attributedString
        conditions.text = "Terms of Service and Privacy Policy"
        conditions.textColor = UIColor(named: "SubtitleColor")
        conditions.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        conditions.snp.makeConstraints { make in
            make.top.equalTo(termsAndConditions.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }


    private func setupGoogleImage() {
        addSubview(googleImage)
        googleImage.image = UIImage(named: "googleimage")
        googleImage.alpha = 0.5
        googleImage.contentMode = .scaleAspectFit
        googleImage.snp.makeConstraints { make in
            make.edges.equalTo(continueWithGoogle).inset(15)
            make.leading.equalToSuperview().offset(-200)
        }
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
}

extension LoginScreenView: UITextFieldDelegate {

    func configureSignInForm() -> (String?, String?)? {
        let emailText = email.isEmptyTextField()
        let passwordText = password.isEmptyTextField()
        if emailText || passwordText {
            return nil
        }
        return (email.text, password.text)
    }
}

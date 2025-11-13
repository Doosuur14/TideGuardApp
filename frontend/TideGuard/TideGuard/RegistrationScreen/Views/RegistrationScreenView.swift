//
//  RegistrationScreenView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 07.04.2025.
//

import UIKit

protocol RegistrationDelegate: AnyObject {
    func didPressRegButton()
    func didPressAlreadyRegisteredButton()
}

final class RegistrationScreenView: UIView {
    lazy var appName: UILabel = UILabel()
    lazy var firstName: UITextField = UITextField()
    lazy var lastName: UITextField = UITextField()
    lazy var email: UITextField = UITextField()
    lazy var password: UITextField = UITextField()
    lazy var city: UITextField = UITextField()
    lazy var terms: UILabel = UILabel()
    lazy var conditions: UILabel = UILabel()
    lazy var registerButton: UIButton = UIButton()
    lazy var alreadyRegistered: UIButton = UIButton()

    weak var delegate: RegistrationDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFunctions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpFunctions() {
        setUpAppname()
        setUpFirstName()
        setUpLastName()
        setUpEmail()
        setUpPassword()
        setUpCity()
        setUpTerms()
        setUpConditions()
        setUpRegisterButton()
        setUpAlreadyReg()
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
    private func setUpFirstName() {
        addSubview(firstName)
        firstName.placeholder = "First Name"
        firstName.backgroundColor = .clear
        firstName.borderStyle = .roundedRect
        firstName.delegate = self
        firstName.textColor = UIColor(named: "SubtitleColor")
        firstName.font = UIFont.systemFont(ofSize: 16)
        firstName.snp.makeConstraints { make in
            make.top.equalTo(appName.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setUpLastName() {
        addSubview(lastName)
        lastName.placeholder = "Last Name"
        lastName.backgroundColor = .clear
        lastName.borderStyle = .roundedRect
        lastName.delegate = self
        lastName.textColor = UIColor(named: "SubtitleColor")
        lastName.font = UIFont.systemFont(ofSize: 16)
        lastName.snp.makeConstraints { make in
            make.top.equalTo(firstName.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)

        }
    }

    private func setUpEmail() {
        addSubview(email)
        email.placeholder = "Email"
        email.backgroundColor = .clear
        email.autocapitalizationType = .none
        email.borderStyle = .roundedRect
        email.delegate = self
        email.textColor = UIColor(named: "SubtitleColor")
        email.font = UIFont.systemFont(ofSize: 16)
        email.snp.makeConstraints { make in
            make.top.equalTo(lastName.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setUpPassword() {
        addSubview(password)
        password.placeholder = "Password"
        password.backgroundColor = .clear
//        password.textContentType = .password
        password.borderStyle = .roundedRect
        password.delegate = self
        password.textColor = UIColor(named: "SubtitleColor")
        password.font = UIFont.systemFont(ofSize: 16)
        password.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setUpCity() {
        addSubview(city)
        city.placeholder = "State"
        city.backgroundColor = .clear
        city.borderStyle = .roundedRect
        city.delegate = self
        city.textColor = UIColor(named: "SubtitleColor")
        city.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setUpTerms() {
        addSubview(terms)
        terms.text = "By selecting Agree and continue, you agree to"
        terms.font = UIFont.systemFont(ofSize: 10, weight: .light)
        terms.textColor = UIColor(named: "SubtitleColor")
        terms.snp.makeConstraints { make in
            make.top.equalTo(city.snp.bottom).offset(50)
            make.centerX.equalToSuperview()

        }
    }

    private func setUpConditions() {
        addSubview(conditions)
        conditions.text = "TideGuard’s Terms of Service and Privacy Policy"
        conditions.font = UIFont.systemFont(ofSize: 10, weight: .light)
        conditions.textColor = UIColor(named: "SubtitileColor")
        conditions.snp.makeConstraints { make in
            make.top.equalTo(terms.snp.bottom).offset(5)
            make.centerX.equalToSuperview()

        }
    }

    private func setUpRegisterButton() {
        addSubview(registerButton)
        registerButton.setTitle("Agree and Continue", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        registerButton.backgroundColor = UIColor(named: "MainColor")
        registerButton.clipsToBounds = true
        let action = UIAction { [weak self] _ in
            self?.delegate?.didPressRegButton()
        }
        registerButton.addAction(action, for: .touchUpInside)
        registerButton.layer.cornerRadius = 10
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(conditions.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setUpAlreadyReg() {
        addSubview(alreadyRegistered)
        alreadyRegistered.setTitle("I already have an account", for: .normal)
        alreadyRegistered.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        alreadyRegistered.setTitleColor(UIColor(named: "MainColor"), for: .normal)
        alreadyRegistered.isEnabled = true
//        alreadyRegistered.backgroundColor = UIColor(named: "Color2")
//        alreadyRegistered.clipsToBounds = true
//        alreadyRegistered.layer.cornerRadius = 10
        let action = UIAction { [weak self] _ in
            self?.delegate?.didPressAlreadyRegisteredButton()
        }
        alreadyRegistered.addAction(action, for: .touchUpInside)
        alreadyRegistered.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
//            make.leading.equalToSuperview().offset(16)
//            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
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

extension RegistrationScreenView: UITextFieldDelegate {
    func configureSignUpForm() -> UserRegistrationData? {
        let isFirstNameEmpty = firstName.isEmptyTextField()
        let isLastNameEmpty = lastName.isEmptyTextField()
        let isEmailEmpty = email.isEmptyTextField()
        let isPasswordEmpty = password.isEmptyTextField()
        let isCityEmpty = city.isEmptyTextField()
        if isEmailEmpty || isPasswordEmpty || isFirstNameEmpty || isLastNameEmpty {
            return nil
        }
        return UserRegistrationData(
            firstname: firstName.text,
            lastname: lastName.text,
            emailText: email.text,
            passwordText: password.text,
            cityText: city.text
        )
    }
}

struct UserRegistrationData {
    let firstname: String?
    let lastname: String?
    let emailText: String?
    let passwordText: String?
    let cityText: String?
}

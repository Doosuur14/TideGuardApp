//
//  EditProfileView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 05.06.2025.
//

import UIKit
import SnapKit

protocol EditProfileDelegate: AnyObject {
    func didTapSaveButton()
    func didCancel()
}

class EditProfileView: UIView {

    lazy var firstName: UITextField = UITextField()
    lazy var lastName: UITextField = UITextField()
    lazy var email: UITextField = UITextField()
    lazy var password: UITextField = UITextField()
    lazy var cityTextField = UITextField()
    lazy var cancelButton = UIButton(type: .system)
    lazy var saveButton: UIButton = UIButton(type: .system)

    weak var delegate: EditProfileDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFunc()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFunc() {
        setupFirstName()
        setupLastName()
        setupEmail()
        setupResidence()
        setupSaveButton()
        setupCancelButton()
    }


    private func setupFirstName() {
        addSubview(firstName)
        firstName.placeholder = "First Name"
        firstName.backgroundColor = .clear
        firstName.borderStyle = .roundedRect
        firstName.textColor = UIColor(named: "SubtitleColor")
        firstName.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }


    private func setupLastName() {
        addSubview(lastName)
        lastName.placeholder = "Last Name"
        lastName.backgroundColor = .clear
        lastName.borderStyle = .roundedRect
        lastName.textColor = UIColor(named: "SubtitleColor")
        lastName.snp.makeConstraints { make in
            make.top.equalTo(firstName.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)

        }
    }

    private func setupEmail() {
        addSubview(email)
        email.placeholder = "Email"
        email.backgroundColor = .clear
        email.autocapitalizationType = .none
        email.borderStyle = .roundedRect
        email.textColor = UIColor(named: "SubtitleColor")
        email.snp.makeConstraints { make in
            make.top.equalTo(lastName.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }


    private func setupResidence() {
        addSubview(cityTextField)
        cityTextField.placeholder = "City Of Residence"
        cityTextField.backgroundColor = .clear
        cityTextField.borderStyle = .roundedRect
        cityTextField.textColor = UIColor(named: "SubtitleColor")
        cityTextField.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setupSaveButton() {
        addSubview(saveButton)
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        saveButton.backgroundColor = UIColor(named: "MainColor")
        saveButton.clipsToBounds = true
        let action = UIAction { [weak self] _ in
            self?.delegate?.didTapSaveButton()
        }
        saveButton.addAction(action, for: .touchUpInside)
        saveButton.layer.cornerRadius = 10
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setupCancelButton() {
        addSubview(cancelButton)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        cancelButton.setTitleColor(.systemRed, for: .normal)
        cancelButton.backgroundColor = UIColor(named: "MainColor")
        cancelButton.clipsToBounds = true
        let action = UIAction { [weak self] _ in
            self?.delegate?.didCancel()
        }
        cancelButton.addAction(action, for: .touchUpInside)
        cancelButton.layer.cornerRadius = 10
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(saveButton.snp.width)
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


extension EditProfileView: UITextFieldDelegate {
    func configureForm() -> UserData? {
        let isFirstNameEmpty = firstName.isEmptyTextField()
        let isLastNameEmpty = lastName.isEmptyTextField()
        let isEmailEmpty = email.isEmptyTextField()
        let isCityEmpty = cityTextField.isEmptyTextField()
        if isEmailEmpty || isFirstNameEmpty || isLastNameEmpty || isCityEmpty {
            return nil
        }
        return UserData(
            firstname: firstName.text,
            lastname: lastName.text,
            emailText: email.text,
            city: cityTextField.text
        )
    }
}


struct UserData {
    let firstname: String?
    let lastname: String?
    let emailText: String?
    let city: String?
}

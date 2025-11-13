//
//  HomeScreenDesignView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 27.03.2025.
//

import UIKit
import SnapKit

protocol HomeViewDelegate: AnyObject {
    func alreadyRegisteredaction()
    func getStartedButtonAction()
}

class HomeScreenDesignView: UIView {
    private lazy var appName: UILabel = UILabel()
    private lazy var slogan: UILabel = UILabel()
    lazy var getStarted: UIButton = UIButton()
    lazy var alreadyRegistered: UIButton = UIButton()
    private lazy var terms: UILabel = UILabel()
    private lazy var conditions: UILabel = UILabel()

    weak var delegate: HomeViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFunctions()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpFunctions() {
        setupAppName()
        setFirstSloganLabel()
        setupGetstartedButton()
        setupAlreadyReg()
        setupTerms()
        setupConditions()
    }

    private func setupAppName() {
        addSubview(appName)
        appName.text = "TideGuard"
        appName.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        appName.textColor = UIColor(named: "MainColor")
        appName.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
    }

    private func setFirstSloganLabel() {
        addSubview(slogan)
        slogan.text = "Stay Safe, Stay Informed"
        slogan.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        slogan.textColor = .subtitle
        slogan.snp.makeConstraints { make in
            make.top.equalTo(appName.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    private func setupGetstartedButton() {
        addSubview(getStarted)
        getStarted.setTitle("Get Started", for: .normal)
        getStarted.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        getStarted.backgroundColor = UIColor(named: "MainColor")
        getStarted.clipsToBounds = true
        getStarted.layer.cornerRadius = 10
        let action = UIAction {  [weak self] _ in
            self?.delegate?.getStartedButtonAction()
        }
        getStarted.addAction(action, for: .touchUpInside)
        getStarted.snp.makeConstraints { make in
            make.top.equalTo(slogan.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
    }
}


    private func setupAlreadyReg() {
        addSubview(alreadyRegistered)
        alreadyRegistered.setTitle("I already have an account", for: .normal)
        alreadyRegistered.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        alreadyRegistered.setTitleColor(.label, for: .normal)
        alreadyRegistered.isEnabled = true
        alreadyRegistered.backgroundColor = UIColor(named: "Color")
        alreadyRegistered.clipsToBounds = true
        alreadyRegistered.layer.cornerRadius = 10
        let action = UIAction { [weak self] _ in
            self?.delegate?.alreadyRegisteredaction()
        }
        alreadyRegistered.addAction(action, for: .touchUpInside)
        alreadyRegistered.snp.makeConstraints { make in
            make.top.equalTo(getStarted.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
    }

    private func setupTerms() {
        addSubview(terms)
        terms.text = "By continuing, you agree to Navigate U’s"
        terms.textColor = UIColor(named: "SubtitileColor")
        terms.font = UIFont.systemFont(ofSize: 10, weight: .light)
        terms.snp.makeConstraints { make in
            make.top.equalTo(alreadyRegistered.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupConditions() {
        addSubview(conditions)
        let attributedString = NSMutableAttributedString(string: "Terms of Service and Privacy Policy")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        conditions.attributedText = attributedString
        conditions.text = "Terms of Service and Privacy Policy"
        conditions.textColor = UIColor(named: "SubtitleColor")
        conditions.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        conditions.snp.makeConstraints { make in
            make.top.equalTo(terms.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }






}

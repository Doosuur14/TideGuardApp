//
//  ProfileView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 08.05.2025.
//

import UIKit
import SnapKit

protocol ProfileViewDelegate: AnyObject {
    func didPressLogoutButton()
    func didPressDeleteButton()
}


final class ProfileView: UIView {

    lazy var avatarImage: UIImageView = UIImageView()
    lazy var firstName: UILabel = UILabel()
    lazy var lastName: UILabel = UILabel()
    lazy var userEmail: UILabel = UILabel()
    lazy var tableView: UITableView = UITableView()
    lazy var logOut: UIButton = UIButton(type: .system)
    lazy var deleteAccount: UIButton = UIButton(type: .system)
    lazy var customSwitch: UISwitch = UISwitch()
    lazy var theme: UILabel = UILabel()
    private let stackView = UIStackView()
    private let buttonStackView = UIStackView()


    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.systemBlue.withAlphaComponent(0.1).cgColor, UIColor.white.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }


    weak var delegate: ProfileViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        setupAvatarImage()
        setupFirstname()
        setupLastname()
        setupUseremail()
        setupStackView()
        setupTableview()
        setupSwitch()
        setupTheme()
        setupButtonStackView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAvatarImage() {
        addSubview(avatarImage)
        avatarImage.clipsToBounds = true
        avatarImage.layer.borderColor =  UIColor(named: "MainColor")?.cgColor
        avatarImage.layer.borderWidth = 1.0
        avatarImage.layer.cornerRadius = 50
        avatarImage.isUserInteractionEnabled = true
        avatarImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(16)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
    }

    private func setupFirstname() {
        addSubview(firstName)
        firstName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        firstName.textColor = .label
    }
    private func setupLastname() {
        addSubview(lastName)
        lastName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lastName.textColor = .label
    }

    private func setupUseremail() {
        addSubview(userEmail)
        userEmail.textColor = .label
        userEmail.font = UIFont.systemFont(ofSize: 12, weight: .light)
    }

    private func setupStackView() {

        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5

        let nameStackView = UIStackView()
        nameStackView.axis = .horizontal
        nameStackView.alignment = .leading
        nameStackView.spacing = 5
        nameStackView.addArrangedSubview(firstName)
        nameStackView.addArrangedSubview(lastName)

        stackView.addArrangedSubview(nameStackView)
        stackView.addArrangedSubview(userEmail)

        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImage.snp.centerY)
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    private func setupTableview() {
        addSubview(tableView)
        tableView.separatorColor = UIColor(named: "MainColor")?.withAlphaComponent(0.3)
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
    }

    private func setupSwitch() {
        customSwitch.isOn = true
        customSwitch.tintColor = .white
        customSwitch.backgroundColor = .systemGray5
        customSwitch.thumbTintColor? = .main
        customSwitch.layer.cornerRadius = 16
        customSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }

    private func setupTheme() {
        theme.text = "Dark Mode"
        theme.textColor =  UIColor(named: "MainColor")
        theme.font = UIFont.systemFont(ofSize: 12, weight: .light)
        theme.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        //theme.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    private func setupButtonStackView() {
        addSubview(buttonStackView)
        addSubview(buttonStackView)
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually


        var logOutConfig = UIButton.Configuration.filled()
        logOutConfig.title = "Log Out"
        logOutConfig.baseBackgroundColor = UIColor(named: "MainColor")
        logOutConfig.cornerStyle = .medium
        logOutConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        logOutConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var attributes = incoming
            attributes.font = .systemFont(ofSize: 15, weight: .medium)
            attributes.foregroundColor = .white
            return attributes
        }
        logOut.configuration = logOutConfig
        logOut.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        buttonStackView.addArrangedSubview(logOut)


        var deleteConfig = UIButton.Configuration.filled()
        deleteConfig.title = "Delete Account"
        deleteConfig.baseBackgroundColor = UIColor.systemRed
        deleteConfig.cornerStyle = .medium
        deleteConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        deleteConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var attributes = incoming
            attributes.font = .systemFont(ofSize: 15, weight: .medium)
            attributes.foregroundColor = .white
            return attributes
        }
        deleteAccount.configuration = deleteConfig
        deleteAccount.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        buttonStackView.addArrangedSubview(deleteAccount)

        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(tableView.snp.bottom).offset(60)
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }


    @objc private func logoutTapped() {
        delegate?.didPressLogoutButton()
    }

    @objc private func deleteTapped() {
        delegate?.didPressDeleteButton()
    }

    func setupDataSource(with dataSource: UITableViewDataSource) {
        self.tableView.dataSource = dataSource
    }

    func setupDelegate(with delegate: UITableViewDelegate) {
        self.tableView.delegate = delegate
    }
}

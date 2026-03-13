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


//final class ProfileView: UIView {
//
//    lazy var avatarImage: UIImageView = UIImageView()
//    lazy var firstName: UILabel = UILabel()
//    lazy var lastName: UILabel = UILabel()
//    lazy var userEmail: UILabel = UILabel()
//    lazy var tableView: UITableView = UITableView()
//    lazy var logOut: UIButton = UIButton(type: .system)
//    lazy var deleteAccount: UIButton = UIButton(type: .system)
//    lazy var customSwitch: UISwitch = UISwitch()
//    lazy var theme: UILabel = UILabel()
//    private let stackView = UIStackView()
//    private let buttonStackView = UIStackView()
//
//
//    private lazy var gradientLayer: CAGradientLayer = {
//        let layer = CAGradientLayer()
//        layer.colors = [UIColor.systemBlue.withAlphaComponent(0.1).cgColor, UIColor.white.cgColor]
//        layer.startPoint = CGPoint(x: 0, y: 0)
//        layer.endPoint = CGPoint(x: 1, y: 1)
//        return layer
//    }()
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//        if gradientLayer.superlayer == nil {
//            layer.insertSublayer(gradientLayer, at: 0)
//        }
//    }
//
//
//    weak var delegate: ProfileViewDelegate?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//
//    private func setupViews() {
//        setupAvatarImage()
//        setupFirstname()
//        setupLastname()
//        setupUseremail()
//        setupStackView()
//        setupTableview()
//        setupSwitch()
//        setupTheme()
//        setupButtonStackView()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupAvatarImage() {
//        addSubview(avatarImage)
//        avatarImage.clipsToBounds = true
//        avatarImage.layer.borderColor =  UIColor(named: "MainColor")?.cgColor
//        avatarImage.layer.borderWidth = 1.0
//        avatarImage.layer.cornerRadius = 50
//        avatarImage.isUserInteractionEnabled = true
//        avatarImage.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
//            make.leading.equalTo(16)
//            make.height.equalTo(100)
//            make.width.equalTo(100)
//        }
//    }
//
//    private func setupFirstname() {
//        addSubview(firstName)
//        firstName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//        firstName.textColor = .label
//    }
//    private func setupLastname() {
//        addSubview(lastName)
//        lastName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
//        lastName.textColor = .label
//    }
//
//    private func setupUseremail() {
//        addSubview(userEmail)
//        userEmail.textColor = .label
//        userEmail.font = UIFont.systemFont(ofSize: 12, weight: .light)
//    }
//
//    private func setupStackView() {
//
//        addSubview(stackView)
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.spacing = 5
//
//        let nameStackView = UIStackView()
//        nameStackView.axis = .horizontal
//        nameStackView.alignment = .leading
//        nameStackView.spacing = 5
//        nameStackView.addArrangedSubview(firstName)
//        nameStackView.addArrangedSubview(lastName)
//
//        stackView.addArrangedSubview(nameStackView)
//        stackView.addArrangedSubview(userEmail)
//
//        stackView.snp.makeConstraints { make in
//            make.centerY.equalTo(avatarImage.snp.centerY)
//            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
//            make.trailing.equalToSuperview().offset(-16)
//        }
//    }
//
//    private func setupTableview() {
//        addSubview(tableView)
//        tableView.separatorColor = UIColor(named: "MainColor")?.withAlphaComponent(0.3)
//        tableView.layer.cornerRadius = 10
//        tableView.clipsToBounds = true
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(avatarImage.snp.bottom).offset(20)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-100)
//        }
//    }
//
//    private func setupSwitch() {
//        customSwitch.isOn = true
//        customSwitch.tintColor = .white
//        customSwitch.backgroundColor = .systemGray5
//        customSwitch.thumbTintColor? = .main
//        customSwitch.layer.cornerRadius = 16
//        customSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//    }
//
//    private func setupTheme() {
//        theme.text = "Dark Mode"
//        theme.textColor =  UIColor(named: "MainColor")
//        theme.font = UIFont.systemFont(ofSize: 12, weight: .light)
//        theme.snp.makeConstraints { make in
//            make.width.equalTo(100)
//        }
//        //theme.widthAnchor.constraint(equalToConstant: 100).isActive = true
//    }
//
//    private func setupButtonStackView() {
//        addSubview(buttonStackView)
//        addSubview(buttonStackView)
//        buttonStackView.axis = .horizontal
//        buttonStackView.spacing = 20
//        buttonStackView.alignment = .center
//        buttonStackView.distribution = .fillEqually
//
//
//        var logOutConfig = UIButton.Configuration.filled()
//        logOutConfig.title = "Log Out"
//        logOutConfig.baseBackgroundColor = UIColor(named: "MainColor")
//        logOutConfig.cornerStyle = .medium
//        logOutConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
//        logOutConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//            var attributes = incoming
//            attributes.font = .systemFont(ofSize: 15, weight: .medium)
//            attributes.foregroundColor = .white
//            return attributes
//        }
//        logOut.configuration = logOutConfig
//        logOut.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
//        buttonStackView.addArrangedSubview(logOut)
//
//
//        var deleteConfig = UIButton.Configuration.filled()
//        deleteConfig.title = "Delete Account"
//        deleteConfig.baseBackgroundColor = UIColor.systemRed
//        deleteConfig.cornerStyle = .medium
//        deleteConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
//        deleteConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//            var attributes = incoming
//            attributes.font = .systemFont(ofSize: 15, weight: .medium)
//            attributes.foregroundColor = .white
//            return attributes
//        }
//        deleteAccount.configuration = deleteConfig
//        deleteAccount.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
//        buttonStackView.addArrangedSubview(deleteAccount)
//
//        buttonStackView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(tableView.snp.bottom).offset(60)
//            make.leading.greaterThanOrEqualToSuperview().offset(16)
//            make.trailing.lessThanOrEqualToSuperview().offset(-16)
//        }
//    }
//
//
//    @objc private func logoutTapped() {
//        delegate?.didPressLogoutButton()
//    }
//
//    @objc private func deleteTapped() {
//        delegate?.didPressDeleteButton()
//    }
//
//    func setupDataSource(with dataSource: UITableViewDataSource) {
//        self.tableView.dataSource = dataSource
//    }
//
//    func setupDelegate(with delegate: UITableViewDelegate) {
//        self.tableView.delegate = delegate
//    }
//}


final class ProfileView: UIView {
    
    lazy var avatarImage: UIImageView = UIImageView()
    lazy var firstName: UILabel = UILabel()
    lazy var lastName: UILabel = UILabel()
    lazy var userEmail: UILabel = UILabel()
    lazy var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    lazy var customSwitch: UISwitch = UISwitch()
    lazy var theme: UILabel = UILabel()

    weak var delegate: ProfileViewDelegate?

    private var accent: UIColor {
        UIColor(named: "MainColor") ?? UIColor(red: 0.25, green: 0.47, blue: 0.72, alpha: 1)
    }

    private let avatarCard = UIView()
    private let avatarRingView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGroupedBackground
        setupAvatarCard()
        setupTableView()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupAvatarCard() {
        avatarCard.backgroundColor = .systemBackground
        avatarCard.layer.cornerRadius = 24
        avatarCard.layer.shadowColor = UIColor.black.cgColor
        avatarCard.layer.shadowOpacity = 0.06
        avatarCard.layer.shadowRadius = 16
        avatarCard.layer.shadowOffset = CGSize(width: 0, height: 4)

        addSubview(avatarCard)
        avatarCard.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        let stripe = UIView()
        stripe.backgroundColor = accent
        stripe.layer.cornerRadius = 24
        stripe.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        avatarCard.addSubview(stripe)
        stripe.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }

        for i in 0..<5 {
            let dot = UIView()
            let size = CGFloat(24 + i * 16)
            dot.backgroundColor = UIColor.white.withAlphaComponent(0.07)
            dot.layer.cornerRadius = size / 2
            stripe.addSubview(dot)
            dot.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(CGFloat(-10 - i * 25))
                make.centerY.equalToSuperview()
                make.width.height.equalTo(size)
            }
        }

        avatarRingView.backgroundColor = .systemBackground
        avatarRingView.layer.cornerRadius = 46
        avatarRingView.layer.borderWidth = 3
        avatarRingView.layer.borderColor = accent.cgColor
        avatarCard.addSubview(avatarRingView)
        avatarRingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(stripe.snp.bottom)
            make.width.height.equalTo(92)
        }

        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 40
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.backgroundColor = accent.withAlphaComponent(0.1)
        avatarImage.image = UIImage(systemName: "person.fill")
        avatarImage.tintColor = accent
        avatarImage.isUserInteractionEnabled = true
        avatarRingView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }

        let badge = UIView()
        badge.backgroundColor = accent
        badge.layer.cornerRadius = 11
        badge.layer.borderWidth = 2
        badge.layer.borderColor = UIColor.systemBackground.cgColor
        avatarCard.addSubview(badge)
        badge.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.trailing.equalTo(avatarRingView.snp.trailing).offset(2)
            make.bottom.equalTo(avatarRingView.snp.bottom).offset(2)
        }
        let cameraIcon = UIImageView(image: UIImage(systemName: "camera.fill"))
        cameraIcon.tintColor = .white
        cameraIcon.contentMode = .scaleAspectFit
        badge.addSubview(cameraIcon)
        cameraIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(11)
        }

        firstName.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        firstName.textColor = .label
        firstName.textAlignment = .center

        lastName.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lastName.textColor = .label
        lastName.textAlignment = .center

        let nameRow = UIStackView(arrangedSubviews: [firstName, lastName])
        nameRow.axis = .horizontal
        nameRow.spacing = 5
        nameRow.alignment = .center


        userEmail.font = UIFont.systemFont(ofSize: 13)
        userEmail.textColor = .secondaryLabel
        userEmail.textAlignment = .center

        let infoStack = UIStackView(arrangedSubviews: [nameRow, userEmail])
        infoStack.axis = .vertical
        infoStack.alignment = .center
        infoStack.spacing = 6

        avatarCard.addSubview(infoStack)
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(avatarRingView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    private func setupTableView() {
        addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.top.equalTo(avatarCard.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }

    func setupDataSource(with dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }

    func setupDelegate(with delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

}

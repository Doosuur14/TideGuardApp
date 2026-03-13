//
//  ProfileTableViewCell.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 08.05.2025.
//

import Foundation
import UIKit

class ProfileTableViewCell: UITableViewCell {

//    lazy var iconImage: UIImageView = UIImageView()
//    lazy var contentLabel: UILabel = UILabel()
//    lazy var redirectButton: UIButton = UIButton()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupIconImage()
//        setupContentlabel()
//        setupButton()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func configureCell(with profile: Profile) {
//        iconImage.image = profile.photo
//        contentLabel.text = profile.label
//    }
//
//    private func setupIconImage() {
//        addSubview(iconImage)
//        iconImage.tintColor = UIColor(named: "MainColor")
//        iconImage.snp.makeConstraints { make in
//            make.leading.equalTo(16)
//            make.top.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.height.equalTo(20)
//        }
//
//    }
//    private func setupContentlabel() {
//        addSubview(contentLabel)
//        contentLabel.textColor = .label
//        contentLabel.font = .systemFont(ofSize: 15, weight: .semibold)
//        contentLabel.snp.makeConstraints { make in
//            make.leading.equalTo(iconImage.snp.trailing).offset(16)
//            make.height.equalTo(25)
//            make.centerY.equalToSuperview()
//        }
//    }
//    private func setupButton() {
//        addSubview(redirectButton)
//        redirectButton.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
//        redirectButton.tintColor = UIColor(named: "MainColor")
//        redirectButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().offset(-16)
//        }
//    }


    lazy var iconImage: UIImageView = UIImageView()
    lazy var contentLabel: UILabel = UILabel()
    lazy var redirectButton: UIButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupIconImage()
        setupContentlabel()
        setupButton()

        let bg = UIView()
        bg.backgroundColor = UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 0.06)
        selectedBackgroundView = bg
    }

    required init?(coder: NSCoder) { fatalError() }
//
//    func configureCell(with profile: Profile) {
//        iconImage.image = profile.photo
//        contentLabel.text = profile.label
//    }

    func configureCell(with profile: Profile, isDestructive: Bool = false) {
        iconImage.image = profile.photo
        contentLabel.text = profile.label

        let color = isDestructive ? UIColor.systemRed : UIColor(named: "MainColor") ?? UIColor(red: 0.25, green: 0.47, blue: 0.72, alpha: 1)
        iconImage.tintColor = color
        contentLabel.textColor = isDestructive ? .systemRed : .label

        if let iconBg = contentView.subviews.first(where: { !($0 is UIImageView) && !($0 is UIButton) && !($0 is UILabel) }) {
            iconBg.backgroundColor = color.withAlphaComponent(0.1)
        }
    }

    private func setupIconImage() {
        contentView.addSubview(iconImage)
        iconImage.tintColor = UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 1)
        iconImage.contentMode = .scaleAspectFit

        let iconBg = UIView()
        iconBg.backgroundColor = UIColor(red: 0.25, green: 0.47, blue: 0.85, alpha: 0.1)
        iconBg.layer.cornerRadius = 8
        contentView.insertSubview(iconBg, belowSubview: iconImage)
        iconBg.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(34)
        }
        iconImage.snp.makeConstraints { make in
            make.center.equalTo(iconBg)
            make.width.height.equalTo(18)
        }
    }

    private func setupContentlabel() {
        contentView.addSubview(contentLabel)
        contentLabel.textColor = .label
        contentLabel.font = .systemFont(ofSize: 15, weight: .medium)
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(66)
            make.centerY.equalToSuperview()
        }
    }

    private func setupButton() {
        contentView.addSubview(redirectButton)
        redirectButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        redirectButton.tintColor = UIColor.tertiaryLabel
        redirectButton.isUserInteractionEnabled = false
        redirectButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(20)
        }
    }
}

extension UITableViewCell {
    static var profileReuseIdentifier: String {
        return String(describing: self)
    }
}

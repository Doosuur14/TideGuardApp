//
//  ReportView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 09.06.2025.
//

import UIKit
import SnapKit

protocol ReportDelegate: AnyObject {
    func didUploadReport(image: UIImage?, description: String)
}


//class ReportView: UIView {
//
//    weak var delegate: ReportDelegate?
//    lazy var imageView = UIImageView()
//    lazy var descriptionTextView = UITextView()
//    lazy var uploadButton = UIButton(type: .system)
//
//
//    private lazy var gradientLayer: CAGradientLayer = {
//        let layer = CAGradientLayer()
//        layer.colors = [UIColor.systemGray6.cgColor, UIColor.white.cgColor]
//        layer.startPoint = CGPoint(x: 0, y: 0)
//        layer.endPoint = CGPoint(x: 1, y: 1)
//        return layer
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupView() {
//        layer.insertSublayer(gradientLayer, at: 0)
//
//        setupImage()
//        setupDescription()
//        setupUploadButton()
//        clipsToBounds = false
//        backgroundColor = .systemBackground
//    }
//
//    private func setupImage() {
//        addSubview(imageView)
//        imageView.contentMode = .scaleAspectFit
//        imageView.isUserInteractionEnabled = true
//        imageView.layer.cornerRadius = 10
//        imageView.clipsToBounds = true
//        imageView.layer.borderWidth = 2
//        imageView.layer.borderColor = UIColor(named: "MainColor")?.cgColor
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        imageView.layer.shadowOpacity = 0.2
//        imageView.layer.shadowRadius = 4
//        imageView.backgroundColor = .systemGray6
//        imageView.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(200)
//        }
//    }
//
//    private func setupDescription() {
//        addSubview(descriptionTextView)
//        descriptionTextView.text = "Enter description here..."
//        descriptionTextView.textColor = .systemGray2
//        descriptionTextView.font = .systemFont(ofSize: 16, weight: .medium)
//        descriptionTextView.layer.cornerRadius = 10
//        descriptionTextView.layer.borderWidth = 1
//        descriptionTextView.layer.borderColor = UIColor(named: "MainColor")?.withAlphaComponent(0.5).cgColor
//        descriptionTextView.layer.masksToBounds = true
//        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//        descriptionTextView.delegate = self
//        descriptionTextView.snp.makeConstraints { make in
//            make.top.equalTo(imageView.snp.bottom).offset(25)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//            make.height.greaterThanOrEqualTo(150)
//        }
//    }
//
//    private func setupUploadButton() {
//        addSubview(uploadButton)
//        uploadButton.setTitle("Upload", for: .normal)
//        uploadButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        uploadButton.setTitleColor(.white, for: .normal)
//        uploadButton.backgroundColor = UIColor(named: "MainColor")
//        uploadButton.clipsToBounds = true
//        uploadButton.layer.cornerRadius = 12
//
//
//        let action = UIAction { [weak self] _ in
//            UIView.animate(withDuration: 0.2, animations: {
//                self?.uploadButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//            }) { _ in
//                UIView.animate(withDuration: 0.2) {
//                    self?.uploadButton.transform = .identity
//                    self?.delegate?.didUploadReport(image: self?.imageView.image, description: self?.descriptionTextView.text ?? "")
//                }
//            }
//        }
//        uploadButton.addAction(action, for: .touchUpInside)
//
//        uploadButton.snp.makeConstraints { make in
//            make.top.equalTo(descriptionTextView.snp.bottom).offset(25)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.equalToSuperview().offset(-20)
//            make.height.equalTo(50)
//            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
//        }
//    }
//}
//
//
//extension ReportView: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "Enter description here..." {
//            textView.text = ""
//            textView.textColor = .label
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Enter description here..."
//            textView.textColor = .systemGray2
//        }
//    }
//}



class ReportView: UIView {

    weak var delegate: ReportDelegate?
    lazy var imageView = UIImageView()
    lazy var descriptionTextView = UITextView()
    lazy var uploadButton = UIButton(type: .system)

    private var accent: UIColor {
        UIColor(named: "MainColor") ?? UIColor(red: 0.25, green: 0.47, blue: 0.72, alpha: 1)
    }

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageCard = UIView()
    private let cameraIcon = UIImageView()
    private let tapHintLabel = UILabel()
    private let descriptionCard = UIView()
    private let locationRow = UIView()
    private let locationIcon = UIImageView()
    private let locationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGroupedBackground
        setupScrollView()
        setupImageCard()
        setupDescriptionCard()
        setupLocationRow()
        setupUploadButton()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
    }

    private func setupImageCard() {
        imageCard.backgroundColor = .systemBackground
        imageCard.layer.cornerRadius = 20
        imageCard.layer.shadowColor = UIColor.black.cgColor
        imageCard.layer.shadowOpacity = 0.06
        imageCard.layer.shadowRadius = 12
        imageCard.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageCard.isUserInteractionEnabled = true
        contentView.addSubview(imageCard)
        imageCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(220)
        }

        // Image view fills the card
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageCard.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        cameraIcon.image = UIImage(systemName: "camera.fill")
        cameraIcon.tintColor = accent
        cameraIcon.contentMode = .scaleAspectFit
        imageCard.addSubview(cameraIcon)
        cameraIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }

        tapHintLabel.text = "Tap to add a photo"
        tapHintLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        tapHintLabel.textColor = .secondaryLabel
        tapHintLabel.textAlignment = .center
        imageCard.addSubview(tapHintLabel)
        tapHintLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraIcon.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }


        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = accent.withAlphaComponent(0.4).cgColor
        dashedBorder.fillColor = UIColor.clear.cgColor
        dashedBorder.lineDashPattern = [8, 4]
        dashedBorder.lineWidth = 1.5
        DispatchQueue.main.async {
            dashedBorder.path = UIBezierPath(
                roundedRect: self.imageCard.bounds,
                cornerRadius: 20
            ).cgPath
            dashedBorder.frame = self.imageCard.bounds
            self.imageCard.layer.addSublayer(dashedBorder)
        }
    }

    private func setupDescriptionCard() {
        descriptionCard.backgroundColor = .systemBackground
        descriptionCard.layer.cornerRadius = 20
        descriptionCard.layer.shadowColor = UIColor.black.cgColor
        descriptionCard.layer.shadowOpacity = 0.06
        descriptionCard.layer.shadowRadius = 12
        descriptionCard.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentView.addSubview(descriptionCard)
        descriptionCard.snp.makeConstraints { make in
            make.top.equalTo(imageCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        let sectionLabel = UILabel()
        sectionLabel.text = "DESCRIPTION"
        sectionLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        sectionLabel.textColor = .tertiaryLabel
        descriptionCard.addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        descriptionTextView.text = "Describe what you see..."
        descriptionTextView.textColor = .tertiaryLabel
        descriptionTextView.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 12, bottom: 12, right: 12)
        descriptionTextView.delegate = self
        descriptionCard.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
            make.height.greaterThanOrEqualTo(120)
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    private func setupLocationRow() {
        locationRow.backgroundColor = .systemBackground
        locationRow.layer.cornerRadius = 14
        contentView.addSubview(locationRow)
        locationRow.snp.makeConstraints { make in
            make.top.equalTo(descriptionCard.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        let locIcon = UIImageView(image: UIImage(systemName: "location.fill"))
        locIcon.tintColor = accent
        locIcon.contentMode = .scaleAspectFit
        locationRow.addSubview(locIcon)
        locIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }

        let locLabel = UILabel()
        locLabel.text = "Location will be attached automatically"
        locLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        locLabel.textColor = .secondaryLabel
        locationRow.addSubview(locLabel)
        locLabel.snp.makeConstraints { make in
            make.leading.equalTo(locIcon.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

        let checkIcon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkIcon.tintColor = .systemGreen
        checkIcon.contentMode = .scaleAspectFit
        locationRow.addSubview(checkIcon)
        checkIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(18)
        }
    }

    private func setupUploadButton() {
        contentView.addSubview(uploadButton)
        uploadButton.setTitle("Submit Report", for: .normal)
        uploadButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.backgroundColor = accent
        uploadButton.layer.cornerRadius = 16
        uploadButton.layer.shadowColor = accent.cgColor
        uploadButton.layer.shadowOpacity = 0.3
        uploadButton.layer.shadowRadius = 10
        uploadButton.layer.shadowOffset = CGSize(width: 0, height: 4)

        let action = UIAction { [weak self] _ in
            UIView.animate(withDuration: 0.15, animations: {
                self?.uploadButton.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    self?.uploadButton.transform = .identity
                }
                self?.delegate?.didUploadReport(
                    image: self?.imageView.image,
                    description: self?.descriptionTextView.text ?? ""
                )
            }
        }
        uploadButton.addAction(action, for: .touchUpInside)

        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(locationRow.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
            make.bottom.equalToSuperview().offset(-30)
        }
    }


    func imageDidChange(_ hasImage: Bool) {
        cameraIcon.isHidden = hasImage
        tapHintLabel.isHidden = hasImage
    }
}

extension ReportView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Describe what you see..." {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe what you see..."
            textView.textColor = .tertiaryLabel
        }
    }
}

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
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUpFunc()
//
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setUpImage() {
//        addSubview(imageView)
//        imageView.contentMode = .scaleAspectFit
//        imageView.isUserInteractionEnabled = true
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor =  UIColor(named: "MainColor")?.cgColor
//        imageView.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(200)
//        }
//    }
//
//    private func setUpDescription() {
//        addSubview(descriptionTextView)
//        descriptionTextView.text = ""
//        descriptionTextView.textColor = .systemGray4
//        descriptionTextView.font = .systemFont(ofSize: 16)
//        descriptionTextView.layer.borderWidth = 1
//        descriptionTextView.layer.borderColor = UIColor(named: "MainColor")?.cgColor
//        descriptionTextView.layer.cornerRadius = 5
//        descriptionTextView.isScrollEnabled = true
//        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        descriptionTextView.snp.makeConstraints { make in
//            make.top.equalTo(imageView.snp.bottom).offset(30)
//            make.leading.equalToSuperview().offset(16)
//            make.trailing.equalToSuperview().offset(-16)
//            make.height.equalTo(150)
//        }
//    }
//
//    private func setUpUploadButton() {
//        addSubview(uploadButton)
//        uploadButton.setTitle("Upload", for: .normal)
//        uploadButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
//        uploadButton.backgroundColor = UIColor(named: "MainColor")
//        uploadButton.clipsToBounds = true
//        let action = UIAction { [weak self] _ in
//            self?.delegate?.didUploadReport(image: self?.imageView.image, description: self?.descriptionTextView.text ?? "")
//        }
//        uploadButton.addAction(action, for: .touchUpInside)
//        uploadButton.layer.cornerRadius = 10
//        uploadButton.snp.makeConstraints { make in
//            make.top.equalTo(descriptionTextView.snp.bottom).offset(30)
//            make.leading.equalToSuperview().offset(16)
//            make.trailing.equalToSuperview().offset(-16)
//            make.height.equalTo(50)
////            make.centerX.equalToSuperview()
//        }
//    }
//
//    private func setUpFunc() {
//        setUpImage()
//        setUpDescription()
//        setUpUploadButton()
//    }
//}



class ReportView: UIView {

    weak var delegate: ReportDelegate?
    lazy var imageView = UIImageView()
    lazy var descriptionTextView = UITextView()
    lazy var uploadButton = UIButton(type: .system)


    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.systemGray6.cgColor, UIColor.white.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.insertSublayer(gradientLayer, at: 0)

        setupImage()
        setupDescription()
        setupUploadButton()
        clipsToBounds = false
        backgroundColor = .systemBackground
    }

    private func setupImage() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowRadius = 4
        imageView.backgroundColor = .systemGray6
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
    }

    private func setupDescription() {
        addSubview(descriptionTextView)
        descriptionTextView.text = "Enter description here..."
        descriptionTextView.textColor = .systemGray2
        descriptionTextView.font = .systemFont(ofSize: 16, weight: .medium)
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor(named: "MainColor")?.withAlphaComponent(0.5).cgColor
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        descriptionTextView.delegate = self
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.greaterThanOrEqualTo(150)
        }
    }

    private func setupUploadButton() {
        addSubview(uploadButton)
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.backgroundColor = UIColor(named: "MainColor")
        uploadButton.clipsToBounds = true
        uploadButton.layer.cornerRadius = 12


        let action = UIAction { [weak self] _ in
            UIView.animate(withDuration: 0.2, animations: {
                self?.uploadButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    self?.uploadButton.transform = .identity
                    self?.delegate?.didUploadReport(image: self?.imageView.image, description: self?.descriptionTextView.text ?? "")
                }
            }
        }
        uploadButton.addAction(action, for: .touchUpInside)

        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}


extension ReportView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter description here..." {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter description here..."
            textView.textColor = .systemGray2
        }
    }
}

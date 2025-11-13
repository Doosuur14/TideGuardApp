//
//  FAQTableViewCell.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 05.06.2025.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    private lazy var contentTitle: UILabel = UILabel()
    private lazy var contentDescription: UITextView = UITextView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpfunc()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with question: FAQ) {
        contentTitle.text = question.question
        contentDescription.text = question.answer
    }

    private func setupContentTitle() {
        addSubview(contentTitle)
        contentTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        contentTitle.textColor = .label
        contentTitle.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(3)
            make.height.equalTo(25)
        }
    }

    private func setupContentDescription() {
        addSubview(contentDescription)
        contentDescription.font = UIFont.systemFont(ofSize: 15, weight: .light)
        contentDescription.textColor = UIColor(named: "SubtitleColor")
        contentDescription.backgroundColor = .clear
        contentDescription.isEditable = false
        contentDescription.isScrollEnabled = false
        contentDescription.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(contentTitle.snp.bottom).offset(3)
            make.trailing.equalTo(-16)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    private func setUpfunc() {
        setupContentTitle()
        setupContentDescription()
    }
}

extension UITableViewCell {
    static var FAQreuseIdentifier: String {
        return String(describing: self)
    }


}

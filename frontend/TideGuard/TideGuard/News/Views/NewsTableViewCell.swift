//
//  NewsTableViewCell.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 11.06.2025.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    private lazy var contentTitle: UILabel = UILabel()
    private lazy var contentDescription: UITextView = UITextView()
    private lazy var contentUrl: UILabel = UILabel()
    private lazy var contentPublishTime: UILabel = UILabel()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpfunc()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with news: News) {
        contentTitle.text = news.title
        contentDescription.text = news.description
        contentUrl.text = news.url
        contentPublishTime.text = news.publishedAt
    }

    private func setupContentTitle() {
        addSubview(contentTitle)
        contentTitle.numberOfLines = 3
        contentTitle.lineBreakMode = .byTruncatingTail
        contentTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        contentTitle.textColor = .label
        contentTitle.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(3)
            //make.height.equalTo(15)
        }
    }

    private func setupContentDescription() {
        addSubview(contentDescription)
        contentDescription.font = UIFont.systemFont(ofSize: 15, weight: .light)
        contentDescription.textColor = UIColor(named: "SubtitleColor")
        contentDescription.backgroundColor = .clear
        contentDescription.isEditable = false
        contentDescription.isScrollEnabled = false
        contentDescription.isSelectable = false
        contentDescription.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(contentTitle.snp.bottom).offset(3)
            make.trailing.equalTo(-16)
            //make.bottom.equalToSuperview().inset(16)
        }
    }


    private func setupContentUrl() {
        addSubview(contentUrl)
        contentUrl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        contentUrl.textColor = UIColor(named: "MainColor")
        contentUrl.numberOfLines = 1
        contentUrl.lineBreakMode = .byTruncatingMiddle
        contentUrl.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(contentDescription.snp.bottom).offset(-3)
            make.trailing.equalTo(-16)
            make.height.equalTo(20)
        }
    }

    private func setupContentPublishTime() {
        addSubview(contentPublishTime)
        contentPublishTime.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        contentPublishTime.textColor = UIColor(named: "SubtitleColor")
        contentPublishTime.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(contentUrl.snp.bottom).offset(3)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-3)
            make.height.equalTo(18)
        }
    }

    private func setUpfunc() {
        setupContentTitle()
        setupContentDescription()
        setupContentUrl()
        setupContentPublishTime()

    }
}

extension UITableViewCell {
    static var NewsReuseIdentifier: String {
        return String(describing: self)
    }

}

//
//  NewsTableViewCell.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 11.06.2025.
//

import UIKit

extension UITableViewCell {
    static var NewsReuseIdentifier: String {
        return String(describing: self)
    }
}


class NewsTableViewCell: UITableViewCell {

    private let cardView      = UIView()
    private let heroImage     = UIImageView()
    private let sourcePill    = UIView()
    private let sourceLabel   = UILabel()
    private let titleLabel    = UILabel()
    private let dateLabel     = UILabel()
    private let readMoreLabel = UILabel()
    private let iconBg        = UIView()

    private var accent: UIColor {
        UIColor(named: "MainColor") ?? UIColor(red: 0.25, green: 0.47, blue: 0.72, alpha: 1)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupCard()
        setupHeroImage()
        setupSourcePill()
        setupTitleLabel()
        setupDateRow()
    }

    required init?(coder: NSCoder) { fatalError() }


    private func setupCard() {
        contentView.addSubview(cardView)
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.07
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupHeroImage() {
        cardView.addSubview(heroImage)
        heroImage.contentMode = .scaleAspectFill
        heroImage.clipsToBounds = true
        heroImage.layer.cornerRadius = 16
        heroImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        heroImage.backgroundColor = accent.withAlphaComponent(0.08)

        let fallback = UIImageView(image: UIImage(systemName: "water.waves"))
        fallback.tintColor = accent.withAlphaComponent(0.4)
        fallback.contentMode = .scaleAspectFit
        heroImage.addSubview(fallback)
        fallback.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(36)
        }

        heroImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(160)
        }
    }

    private func setupSourcePill() {
        cardView.addSubview(sourcePill)
        sourcePill.backgroundColor = accent
        sourcePill.layer.cornerRadius = 10

        sourcePill.addSubview(sourceLabel)
        sourceLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        sourceLabel.textColor = .white
        sourceLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        sourcePill.snp.makeConstraints { make in
            make.top.equalTo(heroImage.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(14)
        }
    }

    private func setupTitleLabel() {
        cardView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sourcePill.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(14)
        }
    }

    private func setupDateRow() {
        dateLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        dateLabel.textColor = .tertiaryLabel

        readMoreLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        readMoreLabel.textColor = accent
        readMoreLabel.text = "Read more →"

        let spacer = UIView()
        let row = UIStackView(arrangedSubviews: [dateLabel, spacer, readMoreLabel])
        row.axis = .horizontal
        row.alignment = .center

        cardView.addSubview(row)
        row.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().offset(-14)
        }
    }


    func configureCell(with news: News) {
        titleLabel.text = news.title
        sourceLabel.text = news.source?.uppercased() ?? "NEWS"
        dateLabel.text = formatDate(news.publishedAt)

        if let urlString = news.urlToImage, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            heroImage.image = nil
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                UIView.transition(
                    with: self?.heroImage ?? UIImageView(),
                    duration: 0.25,
                    options: .transitionCrossDissolve
                ) {
                    self?.heroImage.image = image
                }
            }
        }.resume()
    }

    private func formatDate(_ raw: String?) -> String {
        guard let raw = raw else { return "" }
        let iso = ISO8601DateFormatter()
        guard let date = iso.date(from: raw) else { return raw }
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .none
        return fmt.string(from: date)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        heroImage.image = nil
        titleLabel.text = nil
        sourceLabel.text = nil
        dateLabel.text = nil
    }
}

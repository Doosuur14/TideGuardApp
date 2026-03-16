//
//  NewsViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 11.06.2025.
//

import Foundation
import UIKit

class NewsViewModel {

    @Published var newsItems: [News] = []
    var onNewsUpdated: (() -> Void)?

    func numberOfRowsInSection() -> Int {
        newsItems.count
    }

    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.NewsReuseIdentifier,
            for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(with: newsItems[indexPath.row])
        return cell
    }

    func fetchNews(completion: @escaping (Result<Void, Error>) -> Void) {
        NewsService.shared.fetchNews { [weak self] result in
            switch result {
            case .success(let news):
                self?.newsItems = news
                self?.onNewsUpdated?()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

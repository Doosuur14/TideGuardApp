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

    func heightForRowAt() -> Int {
        return 200
    }

    func numberOfRowsInSection() -> Int {
        newsItems.count
    }

    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.NewsReuseIdentifier, for: indexPath)
                as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let contents = newsItems[indexPath.row]
        cell.configureCell(with: contents)
        return cell
    }


    func fetchNews(completion: @escaping (Result<Void, Error>) -> Void) {
        NewsService.shared.fetchNews { [weak self] result in
            switch result {
            case .success(let news):
                self?.newsItems = news
                //                DispatchQueue.main.async {
                self?.onNewsUpdated?()
                completion(.success(()))
                //}
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

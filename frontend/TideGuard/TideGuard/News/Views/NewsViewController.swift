//
//  NewsViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 11.06.2025.
//

import UIKit
import Combine
import SafariServices


protocol NewsModuleProtocol: AnyObject {
    var newsView: NewsView? { get set }
    var viewModel: NewsViewModel { get set }
}

class NewsViewController: UIViewController, UITableViewDataSource,
                          UITableViewDelegate, NewsModuleProtocol {

    var viewModel: NewsViewModel
    var newsView: NewsView?
    private var cancellables: Set<AnyCancellable> = []

    init(newsView: NewsView? = nil, viewModel: NewsViewModel) {
        self.newsView = newsView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        fetchNewsData()
    }

    private func fetchNewsData() {
        viewModel.fetchNews { result in
            if case .failure(let error) = result {
                print("Failed to fetch news: \(error.localizedDescription)")
            }
        }
    }

    func setUpView() {
        newsView = NewsView(frame: view.bounds)
        view = newsView
        newsView?.setupDelegate(with: self)
        newsView?.setupDataSource(with: self)
        newsView?.tableView.register(
            NewsTableViewCell.self,
            forCellReuseIdentifier: NewsTableViewCell.NewsReuseIdentifier
        )
        viewModel.$newsItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.newsView?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        260
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let urlString = viewModel.newsItems[indexPath.row].url,
              let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

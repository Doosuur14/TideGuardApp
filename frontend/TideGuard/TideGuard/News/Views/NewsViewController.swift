//
//  NewsViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 11.06.2025.
//

import UIKit
import Combine


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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        fetchNewsData()
    }
    

    private func fetchNewsData() {
        print("Attempting to fetch news")
        viewModel.fetchNews { [weak self] result in
            switch result {
            case .success:
                print("News fetched successfully")
            case .failure(let error):
                print("Failed to fetch news: \(error.localizedDescription)")
//                DispatchQueue.main.async { [weak self] in
//                    AlertManager.shared.showUpdateFailureAlert(viewCon: self ?? UIViewController())
//                }
            }
        }
    }


    func setUpView() {
        newsView = NewsView(frame: view.bounds)
        view = newsView
        newsView?.setupDelegate(with: self)
        newsView?.setupDataSource(with: self)
        newsView?.tableView.separatorStyle = .singleLine
        newsView?.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.NewsReuseIdentifier)
        view.backgroundColor = .systemBackground
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
        CGFloat(viewModel.heightForRowAt())
    }
    
}

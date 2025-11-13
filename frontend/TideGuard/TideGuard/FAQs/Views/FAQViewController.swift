//
//  FAQViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 05.06.2025.
//

import UIKit
import Combine

protocol FAQModuleProtocol: AnyObject {
    var faqView: FAQView? { get set }
    var viewModel: FAQViewModel { get set }
}


class FAQViewController: UIViewController, UITableViewDataSource,
                         UITableViewDelegate, FAQModuleProtocol {

    var faqView: FAQView?
    var viewModel: FAQViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(faqView: FAQView? = nil, viewModel: FAQViewModel) {
        self.faqView = faqView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.fetchFAQs()
    }
    

    private func setupView() {
        faqView = FAQView(frame: view.bounds)
        view = faqView
        faqView?.setupDelegate(with: self)
        faqView?.setupDataSource(with: self)
        faqView?.tableView.separatorStyle = .none
        faqView?.tableView.register(FAQTableViewCell.self, forCellReuseIdentifier: FAQTableViewCell.FAQreuseIdentifier)
        view.backgroundColor = .systemBackground
        viewModel.$content
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.faqView?.tableView.reloadData()
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

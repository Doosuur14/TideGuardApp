//
//  NewsView.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 11.06.2025.
//

import UIKit
import SnapKit

class NewsView: UIView {

    lazy var tableView: UITableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        addSubview(tableView)
        tableView.separatorColor = UIColor(named: "MainColor")?.withAlphaComponent(0.3)
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }

    func setupDataSource(with dataSource: UITableViewDataSource) {
        self.tableView.dataSource = dataSource
    }
    
    func setupDelegate(with delegate: UITableViewDelegate) {
        self.tableView.delegate = delegate
    }
}

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
    
    private var accent: UIColor {
        UIColor(named: "MainColor") ?? UIColor(red: 0.25, green: 0.47, blue: 0.72, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemGroupedBackground
        setupTableView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupDataSource(with dataSource: UITableViewDataSource) { tableView.dataSource = dataSource }
    func setupDelegate(with delegate: UITableViewDelegate)       { tableView.delegate = delegate }
}

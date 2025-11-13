//
//  FAQViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 05.06.2025.
//

import Foundation
import UIKit

class FAQViewModel {
    @Published var content: [FAQ] = []
    var reloadTableView: (() -> Void)?

    func heightForRowAt() -> Int {
        return 150
    }

    func numberOfRowsInSection() -> Int {
        content.count
    }


    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.FAQreuseIdentifier, for: indexPath)
                as? FAQTableViewCell else {
                return UITableViewCell()
        }
        let contents = content[indexPath.row]
        cell.configureCell(with: contents)
        return cell
    }

    func fetchFAQs() {
        ProfileService.shared.fetchFAQs { [weak self] result in
            switch result {
            case .success(let faqs):
                self?.content = faqs
            case .failure(let error):
                print("⚠️ Error fetching FAQs: \(error)")
            }
        }
    }

    

}

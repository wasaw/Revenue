//
//  HomeDataSource.swift
//  Revenue
//
//  Created by Александр Меренков on 16.11.2023.
//

import UIKit

final class HomeDataSource: UITableViewDiffableDataSource<String, HomeRemainsItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reuseIdentifire, for: indexPath) as? HomeCell else {
                return UITableViewCell()
            }
            if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                cell.separatorInset.left = tableView.frame.width
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}

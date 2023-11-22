//
//  HomeRemainsDataSource.swift
//  Revenue
//
//  Created by Александр Меренков on 22.11.2023.
//

import UIKit

final class HomeRemainsDataSource: UITableViewDiffableDataSource<HomeRevenueSections, HomeRevenueItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reuseIdentifire, for: indexPath) as? HomeCell else {
                return UITableViewCell()
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}

//
//  HomeGoalsDataSource.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit

final class HomeGoalsDataSource: UITableViewDiffableDataSource<HomeGoalsSections, HomeGoalsItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeGoalsCell.reuseIdentifire, for: indexPath) as? HomeGoalsCell else {
                return UITableViewCell()
            }
//            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}


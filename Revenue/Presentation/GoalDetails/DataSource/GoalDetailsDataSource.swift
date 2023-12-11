//
//  GoalDetailsDataSource.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit

final class GoalDetailsDataSource: UITableViewDiffableDataSource<GoalDetailsSections, GoalDetailsItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GoalDetailsCell.reuseIdentifire, for: indexPath) as? GoalDetailsCell else {
                return UITableViewCell()
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}

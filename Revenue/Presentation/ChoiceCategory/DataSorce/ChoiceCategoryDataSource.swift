//
//  ChoiceCategoryDataSource.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import UIKit

final class ChoiceCategoryDataSource: UITableViewDiffableDataSource<TableCategorySections, TableCategoryItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChoiceCategoryCell.reuseIdentifire, for: indexPath) as? ChoiceCategoryCell else {
                return UITableViewCell()
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}

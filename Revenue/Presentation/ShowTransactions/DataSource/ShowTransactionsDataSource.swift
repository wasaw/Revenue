//
//  ShowTransactionsDataSource.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import UIKit

final class ShowTransactionsDataSource: UITableViewDiffableDataSource<ShowTransactionsCategorySections, ShowTransactionsCategoryItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowTransactionsCell.reuseIdentifire, for: indexPath) as? ShowTransactionsCell else {
                return UITableViewCell()
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}

//
//  CalendarDataSource.swift
//  Revenue
//
//  Created by Александр Меренков on 30.11.2023.
//

import UIKit

final class CalendarDataSource: UITableViewDiffableDataSource<CalendarSections, CalendarItem> {
    init(_ tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarCell.reuseIdentifire, for: indexPath) as? CalendarCell else {
                return UITableViewCell()
            }
            cell.configure(with: itemIdentifier)
            return cell
        }
    }
}

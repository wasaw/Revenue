//
//  HomeRemainsView.swift
//  Revenue
//
//  Created by Александр Меренков on 22.11.2023.
//

import UIKit
import SnapKit

protocol HomeRemainsViewProtocol: AnyObject {
    func details(at index: Int, in section: Int)
}

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let balanceTitlePaddingTop: CGFloat = 20
    static let balanceLabelPaddingTop: CGFloat = 8
    static let balanceViewHeight: CGFloat = 100
    static let headerViewHeight: CGFloat = 45
    static let headerLabelPaddingTop: CGFloat = 5
}

final class HomeRemainsView: UIView {
    
// MARK: - Properties
    
    weak var delegate: HomeRemainsViewProtocol?
    
    private lazy var balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .balanceBackground
        return view
    }()
    private lazy var balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Текущий остаток"
        label.font = UIFont(name: "MontserratRoman-Medium", size: 16)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Bold", size: 32)
        label.textColor = .incomeCash
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        return table
    }()
    private lazy var dataSource = HomeDataSource(tableView)
    private var transactions: [HomeTransactions] = []
    
// MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpes
    
    private func configureUI() {
        configureBalanceView()
        configureTableView()

        backgroundColor = .white
    }
    
    private func configureBalanceView() {
        addSubview(balanceView)
        balanceView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(Constants.balanceViewHeight)
        }
        
        balanceView.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.balanceTitlePaddingTop)
        }
        
        balanceView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(Constants.balanceLabelPaddingTop)
        }
    }
    
    private func configureTableView() {
        tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseIdentifire)
        addSubview(tableView)
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(balanceView.snp.bottom)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setupDataSource(_ transactions: [HomeTransactions]) {
        self.transactions = transactions
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(sectionsArray)
        transactions.forEach { transaction in
            snapshot.appendItems(transaction.item, toSection: transaction.sections[0])
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupTotal(_ total: Double) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        guard let balance = formatter.string(from: total as NSNumber) else { return }
        balanceLabel.text = balance + " c"
    }
}

// MARK: - UITableViewDelegate

extension HomeRemainsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.width,
                                              height: Constants.headerViewHeight))
        let label = UILabel()
        label.frame = CGRect(x: Constants.horizontalPadding,
                             y: Constants.headerLabelPaddingTop,
                             width: tableView.frame.width - Constants.horizontalPadding,
                             height: Constants.headerViewHeight - Constants.headerLabelPaddingTop)
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "dd.MM.YYYY"
        let nowday = dayDateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date())
        let yesterday = dayDateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
        if sectionsArray[section] == nowday {
            label.text = "Сегодня"
        } else if sectionsArray[section] == yesterday {
            label.text = "Вчера"
        } else {
            label.text = sectionsArray[section]
        }
        label.font = UIFont(name: "Inter-Regular_Bold", size: 16)
        label.textColor = .titleColorGray
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.details(at: indexPath.row, in: indexPath.section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.headerViewHeight
    }
}

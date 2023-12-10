//
//  ShowTransactionsViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let tablePaddingTop: CGFloat = 10
    static let headerViewHeight: CGFloat = 45
    static let headerLabelPaddingTop: CGFloat = 5
}

final class ShowTransactionViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ShowTransactionsViewControllerOutput
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "chevron-left"), for: .normal)
        btn.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return btn
    }()
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = ShowTransactionsDataSource(tableView)
// MARK: - Lifecycle
    
    init(output: ShowTransactionsViewControllerOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barStyle = .default
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backButtonTitle = ""
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureTableView()
        
        let leftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButton
        view.backgroundColor = .backgroundLightGray
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.sectionHeaderTopPadding = 0
        tableView.register(ShowTransactionsCell.self, forCellReuseIdentifier: ShowTransactionsCell.reuseIdentifire)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.tablePaddingTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    }
    
    private func setupDataSource(_ transactions: [ShowTransactions]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(sectionsShowArray)
        transactions.forEach { transaction in
            snapshot.appendItems(transaction.items, toSection: transaction.sections[0])
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
// MARK: - Selectors
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - ShowTransactionsViewControllerInput

extension ShowTransactionViewController: ShowTransactionsViewControllerInput {
    func setTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setTransactions(for items: [ShowTransactions]) {
        setupDataSource(items)
    }
}

// MARK: - UITableViewDelegate

extension ShowTransactionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.showDetailed(at: indexPath.row)
    }
    
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
        if sectionsShowArray[section] == nowday {
            label.text = "Сегодня"
        } else if sectionsShowArray[section] == yesterday {
            label.text = "Вчера"
        } else {
            label.text = sectionsShowArray[section]
        }
        label.font = UIFont(name: "Inter-Regular_Bold", size: 16)
        label.textColor = .titleColorGray
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.headerViewHeight
    }
}

//
//  ShowTransactionsViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let tablePaddingTop: CGFloat = 10
}

final class ShowTransactionViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ShowTransactionsViewControllerOutput
    
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
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backButtonTitle = ""
       
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Title"

        configureTableView()
        let backImage = UIImage(named: "chevron-left")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        view.backgroundColor = .backgroundLightGray
        setupDataSource([ShowTransactionsCategoryItem(image: "business", amount: 200, comment: "", date: "12:50")])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(ShowTransactionsCell.self, forCellReuseIdentifier: ShowTransactionsCell.reuseIdentifire)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.tablePaddingTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.backgroundColor = .white
    }
    
    private func setupDataSource(_ transactions: [ShowTransactionsCategoryItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(ShowTransactionsCategorySections.allCases)
        snapshot.appendItems(transactions)
        dataSource.apply(snapshot)
    }
}

// MARK: - ShowTransactionsViewControllerInput

extension ShowTransactionViewController: ShowTransactionsViewControllerInput {
    
}

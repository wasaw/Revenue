//
//  ShowAllDetailsViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let tablePaddingTop: CGFloat = 10
}

final class ShowAllDetailsViewController: UIViewController {
    
// MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "chevron-left"), for: .normal)
        btn.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return btn
    }()
    private let goalItems: [GoalDetilsItem]
        
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = GoalDetailsDataSource(tableView)
// MARK: - Lifecycle
    
    init(goalItems: [GoalDetilsItem]) {
        self.goalItems = goalItems
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.backButtonTitle = ""
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
        configureTableView()
        navigationItem.title = "История взносов"
        
        let leftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButton
        view.backgroundColor = .backgroundLightGray
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(GoalDetailsCell.self, forCellReuseIdentifier: GoalDetailsCell.reuseIdentifire)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.tablePaddingTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.delegate = self
        tableView.backgroundColor = .white
        setupDataSource(goalItems)
    }
    
    private func setupDataSource(_ transactions: [GoalDetilsItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(GoalDetailsSections.allCases)
        snapshot.appendItems(transactions)
        dataSource.apply(snapshot)
    }
    
// MARK: - Helpers
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MAKR: - UITableViedDelegate

extension ShowAllDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EditSelectedDetail(goalItem: goalItems[indexPath.row])
        navigationController?.pushViewController(vc, animated: false)
    }
}

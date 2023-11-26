//
//  HomeRevenueView.swift
//  Revenue
//
//  Created by Александр Меренков on 22.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let graphViewHeight: CGFloat = 230
    static let horizontalPadding: CGFloat = 16
    static let addRevenueBtnHeight: CGFloat = 54
    static let addRevenuePaddingBottom: CGFloat = 8
    static let cornerRadius: CGFloat = 12
}

final class HomeRevenueView: UIView {
    
// MARK: - Properties
    
    private lazy var graphView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    private lazy var dataSource = HomeRemainsDataSource(tableView)
    
    private lazy var addRevenueBtn: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setTitle("Добавить доход", for: .normal)
        btn.layer.cornerRadius = Constants.cornerRadius
        btn.backgroundColor = .applyButton
        btn.addTarget(self, action: #selector(handleAddRevenue), for: .touchUpInside)
        return btn
    }()
    
// MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        addSubview(graphView)
        graphView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.graphViewHeight)
        }
        
        addSubview(tableView)
        tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseIdentifire)
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(graphView.snp.bottom)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addSubview(addRevenueBtn)
        addRevenueBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Constants.addRevenuePaddingBottom)
            make.height.equalTo(Constants.addRevenueBtnHeight)
        }
        backgroundColor = .white
    }
    
    func setupDataSource(_ items: [HomeRevenueItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(HomeRevenueSections.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
    
// MARK: - Selectors
    
    @objc private func handleAddRevenue() {
        
    }
}

// MARK: - UITableViewDelegate

extension HomeRevenueView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

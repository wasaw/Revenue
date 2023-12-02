//
//  HomeGoalsView.swift
//  Revenue
//
//  Created by Александр Меренков on 22.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let balanceTitlePaddingTop: CGFloat = 20
    static let balanceLabelPaddingTop: CGFloat = 8
    static let balanceViewHeight: CGFloat = 100
    static let segmentPaddingTop: CGFloat = 28
    static let segmentHeight: CGFloat = 38
    static let tablePaddingTop: CGFloat = 18
    static let cornerRadius: CGFloat = 12
    static let addGoalBtnHeight: CGFloat = 54
    static let addGoalPaddingBottom: CGFloat = 8
}

final class HomeGoalsView: UIView {
    
// MARK: - Properties
    
    private lazy var balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .balanceBackground
        return view
    }()
    private lazy var balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Общие накопления"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "390 000c"
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .incomeCash
        return label
    }()
    
    private lazy var segmentItems = ["Активные цели", "Достигнутые цели"]
    private lazy var segmentController: UISegmentedControl = {
        let sc = UISegmentedControl(items: segmentItems)
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([.foregroundColor: UIColor.lightGray,
                                   .font: UIFont.systemFont(ofSize: 16)], for: .normal)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                   .font: UIFont.systemFont(ofSize: 16)], for: .selected)
        sc.selectedSegmentTintColor = .black
        sc.addTarget(self, action: #selector(handleSegmentController), for: .valueChanged)
        return sc
    }()
    
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = HomeGoalsDataSource(tableView)
    
    private lazy var addGoalBtn: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setTitle("Добавить цель", for: .normal)
        btn.layer.cornerRadius = Constants.cornerRadius
        btn.backgroundColor = .applyButton
        btn.addTarget(self, action: #selector(handleAddGoal), for: .touchUpInside)
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
        configureCapitalView()
        configureSegment()
        configureTableView()
        configureButton()
        
        backgroundColor = .white
    }
    
    private func configureCapitalView() {
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
    
    private func configureSegment() {
        addSubview(segmentController)
        segmentController.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(balanceView.snp.bottom).offset(Constants.segmentPaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.segmentHeight)
        }
    }
    
    private func configureTableView() {
        addSubview(tableView)
        tableView.register(HomeGoalsCell.self, forCellReuseIdentifier: HomeGoalsCell.reuseIdentifire)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(segmentController.snp.bottom).offset(Constants.tablePaddingTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.backgroundColor = .white
        setupDataSource([HomeGoalsItem(image: "", title: "")])
    }
    
    private func configureButton() {
        addSubview(addGoalBtn)
        addGoalBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-Constants.addGoalPaddingBottom)
            make.height.equalTo(Constants.addGoalBtnHeight)
        }
    }
    
    func setupDataSource(_ items: [HomeGoalsItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(HomeGoalsSections.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
    
// MARK: - Selectors
    
    @objc private func handleSegmentController() {
        
    }
    
    @objc private func handleAddGoal() {
        
    }
}

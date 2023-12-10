//
//  HomeTransactionsView.swift
//  Revenue
//
//  Created by Александр Меренков on 22.11.2023.
//

import UIKit
import SnapKit
import DGCharts

private enum Constants {
    static let graphViewHeight: CGFloat = 230
    static let tableViewPaddingTop: CGFloat = 30
    static let horizontalPadding: CGFloat = 16
    static let addRevenueBtnHeight: CGFloat = 54
    static let addRevenuePaddingBottom: CGFloat = 8
    static let cornerRadius: CGFloat = 12
}

final class HomeTransactionsView: UIView {
    
// MARK: - Properties
    
    private let output: HomeTransactionsOutput
    private lazy var graphView: PieChartView = {
        let view = PieChartView()
        view.holeRadiusPercent = 0.75
        view.rotationAngle = 0
        view.rotationEnabled = false
        view.legend.enabled = false
        view.backgroundColor = .backgroundLightGray
        return view
    }()
    private lazy var graphLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Medium", size: 16)
        label.textColor = .incomeCash
        return label
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
    
    init(output: HomeTransactionsOutput) {
        self.output = output

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
        
        graphView.addSubview(graphLabel)
        graphLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addSubview(tableView)
        tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseIdentifire)
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(graphView.snp.bottom).offset(Constants.tableViewPaddingTop)
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
    
    private func setupButton(_ isRevenue: Bool) {
        if isRevenue {
            addRevenueBtn.setTitle("Добавить доход", for: .normal)
            addRevenueBtn.backgroundColor = .applyButton
        } else {
            addRevenueBtn.setTitle("Добавить расход", for: .normal)
            addRevenueBtn.backgroundColor = .deleteButton
        }
    }
    
    func setupDataSource(_ items: [HomeRevenueItem]) {
        if !items.isEmpty {
            setupButton(items[0].isRevenue)
        }

        var entries: [PieChartDataEntry] = Array()
        var total: Double = 0
        for item in items {
            entries.append(PieChartDataEntry(value: item.percent))
            total += item.amount
        }

        let dataSet = PieChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [.red, .blue, .orange, .brown, .cyan, .magenta, .purple]
        graphView.data = PieChartData(dataSet: dataSet)

        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(HomeRevenueSections.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = " "
            formatter.groupingSize = 3
            return formatter
        }()
        guard let string = numberFormatter.string(from: total as NSNumber) else { return }
        graphLabel.text = string + "c"
    }
    
// MARK: - Selectors
    
    @objc private func handleAddRevenue() {
        output.showAddTransaction()
    }
}

// MARK: - UITableViewDelegate

extension HomeTransactionsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.showDetails(at: indexPath.row)
    }
}

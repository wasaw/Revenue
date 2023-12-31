//
//  GoalDetailsCell.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 12
}

final class GoalDetailsCell: UITableViewCell {
    static let reuseIdentifire = "goalDetailsCell"
    
// MARK: - Properties
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Medium", size: 16)
        label.textColor = .black
        return label
    }()
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Medium", size: 16)
        label.textColor = .incomeCash
        return label
    }()
    
// MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }
    }
    
    func configure(with item: GoalDetailsItem) {
        amountLabel.text = item.amountForOutput
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        dateLabel.text = formatter.string(from: item.date)
    }
}

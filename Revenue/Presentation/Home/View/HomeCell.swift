//
//  HomeCell.swift
//  Revenue
//
//  Created by Александр Меренков on 16.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let ivVerticalPadding: CGFloat = 8
    static let labelVerticalPadding: CGFloat = 2
}

final class HomeCell: UITableViewCell {
    static let reuseIdentifire = "homeCell"
    
// MARK: - Properties
    
    private lazy var categoryIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .incomeCash
        return label
    }()
    private lazy var rightBottomLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
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
        contentView.addSubview(categoryIV)
        categoryIV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.ivVerticalPadding)
            make.bottom.equalToSuperview().offset(-Constants.ivVerticalPadding)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryIV.snp.trailing).offset(Constants.horizontalPadding)
            make.top.equalTo(categoryIV.snp.top).offset(Constants.labelVerticalPadding)
        }
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryIV.snp.trailing).offset(Constants.horizontalPadding)
            make.bottom.equalTo(categoryIV.snp.bottom).offset(-Constants.labelVerticalPadding)
        }
        
        contentView.addSubview(rightBottomLabel)
        rightBottomLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalTo(categoryIV.snp.bottom).offset(-Constants.labelVerticalPadding)
        }
    }
    
    func configure(with item: HomeRemainsItem) {
        categoryIV.image = UIImage(named: item.image)
        titleLabel.text = item.title
        amountLabel.text = String(item.amount)
        rightBottomLabel.text = item.time
    }
    
    func configure(with item: HomeRevenueItem) {
        categoryIV.image = UIImage(named: item.image)
        titleLabel.text = item.title
        amountLabel.text = String(item.amount)
        rightBottomLabel.text = String(item.percent) + "%"
        
        rightBottomLabel.font = UIFont.systemFont(ofSize: 16)
        rightBottomLabel.textColor = .black
    }
}

//
//  ShowTransactionsCell.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let ivVerticalPadding: CGFloat = 8
    static let labelVerticalPadding: CGFloat = 2
}

final class ShowTransactionsCell: UITableViewCell {
    static let reuseIdentifire = "showTransactionsCell"
    
// MARK: - Properties
    
    private lazy var categoryIV: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var timeLabel: UILabel = {
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
    
// MARK: - Properties
    
    private func configureUI() {
        contentView.addSubview(categoryIV)
        categoryIV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.ivVerticalPadding)
            make.bottom.equalToSuperview().offset(-Constants.ivVerticalPadding)
        }
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryIV.snp.trailing).offset(Constants.horizontalPadding)
            make.top.equalTo(categoryIV.snp.top).offset(Constants.labelVerticalPadding)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryIV.snp.trailing).offset(Constants.horizontalPadding)
            make.bottom.equalTo(categoryIV.snp.bottom).offset(-Constants.labelVerticalPadding)
        }
    }
    
    func configure(with item: ShowTransactionsCategoryItem) {
        categoryIV.image = UIImage(named: item.image)
        amountLabel.text = String(item.amount) + "c"
        timeLabel.text = item.date
    }
}

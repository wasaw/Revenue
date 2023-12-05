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
    static let verticalPadding: CGFloat = 8
    static let labelVerticalPadding: CGFloat = 2
    static let commentViewHeight: CGFloat = 34
    static let commentPaddingTop: CGFloat = 16
    static let categoryIV: CGFloat = 50
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
    private lazy var commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .dateButton
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .titleColorGray
        label.layer.zPosition = 2
        return label
    }()
    private var categoryBottomConstraint: NSLayoutConstraint?
    
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
            make.top.equalToSuperview().offset(Constants.verticalPadding)
        }
        categoryBottomConstraint = categoryIV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.categoryIV)
        categoryBottomConstraint?.isActive = true
        
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
        
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryIV.snp.leading).offset(Constants.verticalPadding)
            make.top.equalTo(categoryIV.snp.bottom).offset(Constants.commentPaddingTop)
        }
        
        contentView.addSubview(commentView)
        commentView.snp.makeConstraints { make in
            make.leading.equalTo(categoryIV.snp.leading)
            make.top.equalTo(categoryIV.snp.bottom).offset(Constants.verticalPadding)
            make.trailing.equalTo(commentLabel.snp.trailing).offset(Constants.verticalPadding)
            make.height.equalTo(Constants.commentViewHeight)
        }
    }
    
    func configure(with item: ShowTransactionsCategoryItem) {
        categoryIV.image = UIImage(named: item.image)
        amountLabel.text = item.amountForOutput
        timeLabel.text = item.date
        if item.comment == "" {
            categoryBottomConstraint?.constant = -Constants.verticalPadding
            commentView.isHidden = true
        }
        commentLabel.text = item.comment
    }
}

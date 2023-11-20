//
//  ChoiceCategoryCell.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 8
}

final class ChoiceCategoryCell: UITableViewCell {
    static let reuseIdentifire = "choiceCategoryCell"
    
    // MARK: - Properties
    
    private lazy var typeImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    private lazy var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    private lazy var checkmarkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "checkmark")
        return iv
    }()
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                checkmarkImageView.isHidden = false
            } else {
                checkmarkImageView.isHidden = true
            }
        }
    }
    
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
        contentView.addSubview(typeImageView)
        typeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }
        
        contentView.addSubview(typeTitleLabel)
        typeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeImageView.snp.trailing).offset(Constants.horizontalPadding)
            make.centerY.equalTo(typeImageView.snp.centerY)
        }
        
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.centerY.equalTo(typeImageView.snp.centerY)
        }
    }
    
    func configure(with item: TableCategoryItem) {
        typeImageView.image = UIImage(named: item.image)
        typeTitleLabel.text = item.title
        isSelected = item.isSelected
    }
}

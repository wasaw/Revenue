//
//  CalendarCell.swift
//  Revenue
//
//  Created by Александр Меренков on 30.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
}

final class CalendarCell: UITableViewCell {
    static let reuseIdentifire = "calendarCell"
    
// MARK: - Properties
    private lazy var calendarIV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "calendarCell")
        return iv
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Bold", size: 18)
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
        contentView.addSubview(calendarIV)
        calendarIV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(calendarIV.snp.trailing).offset(Constants.horizontalPadding)
            make.centerY.equalTo(calendarIV.snp.centerY)
        }
        
        contentView.addSubview(checkmarkImageView)
        checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.centerY.equalTo(calendarIV.snp.centerY)
        }
    }
    
    func configure(with item: CalendarItem) {
        titleLabel.text = item.title
        isSelected = item.isSelected
    }
}

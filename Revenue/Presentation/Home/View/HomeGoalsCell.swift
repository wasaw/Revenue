//
//  HomeGoalsCell.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let imageWidht: CGFloat = 42
    static let imageHeight: CGFloat = 42
    static let progressBarPaddingTop: CGFloat = 12
    static let labelPaddingTop: CGFloat = 2
    static let imageRadius: CGFloat = 8
}

final class HomeGoalsCell: UITableViewCell {
    static let reuseIdentifire = "goalsCell"
    
// MARK: - Properties
    
    private lazy var logoImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "goal1")
        view.layer.cornerRadius = Constants.imageRadius
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Накопить на ZEEKR из авто салона"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .bottomUnderline
        progressView.clipsToBounds = true
        return progressView
    }()
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "340 000 с из 4 000 000 с"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "до 21.12.2024"
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
        contentView.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.width.equalTo(Constants.imageWidht)
            make.height.equalTo(Constants.imageHeight)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(logoImage.snp.trailing).offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.centerY.equalTo(logoImage.snp.centerY)
        }
        
        contentView.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(logoImage.snp.bottom).offset(Constants.progressBarPaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.verticalPadding)
        }
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(progressBar.snp.bottom).offset(Constants.labelPaddingTop)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(Constants.labelPaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        
        progressBar.setProgress(0.8, animated: true)
        backgroundColor = .white
    }
}

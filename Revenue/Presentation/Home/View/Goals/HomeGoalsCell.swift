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
        view.layer.cornerRadius = Constants.imageRadius
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var dateLabel: UILabel = {
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
        
        backgroundColor = .white
    }
    
    func configure(with item: HomeGoalsItem) {
        titleLabel.text = item.title
        amountLabel.text = String(format: "%.0f", item.introduced) + " с из " + String(format: "%.0f", item.total) + "с"
        let progress: Float = Float(item.introduced / item.total)
        progressBar.setProgress(progress, animated: true)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        dateLabel.text = "до " + formatter.string(from: item.date)
        
        guard let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = directoryUrl.appendingPathComponent(item.image)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                let fileData = try Data(contentsOf: fileUrl)
                guard let image = UIImage(data: fileData) else { return }
                logoImage.image = image
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//
//  DeleteViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 26.11.2023.
//

import UIKit
import SnapKit

protocol DeleteViewControllerDelegate: AnyObject {
    func delete()
    func cancel()
}

private enum Constants {
    static let width: CGFloat = 328
    static let height: CGFloat = 410
    static let cornerRadius: CGFloat = 25
    static let imageViewPaddingTop: CGFloat = 30
    static let horizontalPadding: CGFloat = 12
    static let labelPaddingTop: CGFloat = 25
    static let buttonWidth: CGFloat = 296
    static let buttonHeight: CGFloat = 54
    static let buttonRadius: CGFloat = 12
    static let deleteButtonPaddingTop: CGFloat = 20
    static let cancelButtonPaddingTop: CGFloat = 20
}

final class DeleteViewController: UIViewController {
    
// MARK: - Properties
    
    weak var delegate: DeleteViewControllerDelegate?
    private lazy var alertView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .white
        return view
    }()
    private lazy var trashIV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bigTrash")
        return iv
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы действительно хотите удалить данную транзакцию?"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .blackTitle
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Удалить", for: .normal)
        btn.layer.cornerRadius = Constants.buttonRadius
        btn.layer.shadowColor = UIColor.deleteButtonShadow.cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btn.layer.shadowOpacity = 0.7
        btn.layer.shadowRadius = 4
        btn.layer.masksToBounds = false
        btn.backgroundColor = .deleteButton
        btn.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        return btn
    }()
    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Отмена", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = Constants.buttonRadius
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return btn
    }()
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var dimmedView = UIVisualEffectView(effect: blurEffect)
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(Constants.width)
            make.height.equalTo(Constants.height)
        }
        modalPresentationStyle = .overCurrentContext
        
        alertView.addSubview(trashIV)
        trashIV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.imageViewPaddingTop)
            make.centerX.equalToSuperview()
        }
        
        alertView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(trashIV.snp.bottom).offset(Constants.labelPaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        
        alertView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.deleteButtonPaddingTop)
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
            make.centerX.equalToSuperview()
        }
        
        alertView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).offset(Constants.cancelButtonPaddingTop)
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
            make.centerX.equalToSuperview()
        }
    }
    
// MARK: - Selectors
    
    @objc private func handleDeleteButton() {
        delegate?.delete()
    }
    
    @objc private func handleCancelButton() {
        delegate?.cancel()
    }
}

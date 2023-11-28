//
//  OtherCategory.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import UIKit
import SnapKit

protocol OtherCategoryViewControllerDelegate: AnyObject {
    func addOther()
    func cancel()
}

private enum Constants {
    static let width: CGFloat = 343
    static let height: CGFloat = 273
    static let cornerRadius: CGFloat = 25
    static let titlePaddingTop: CGFloat = 25
    static let horizontalPadding: CGFloat = 12
    static let labelPaddingTop: CGFloat = 25
    static let buttonWidth: CGFloat = 296
    static let buttonHeight: CGFloat = 54
    static let buttonRadius: CGFloat = 12
    static let textFieldViewPaddingTop: CGFloat = 20
    static let textFieldViewWidth: CGFloat = 296
    static let textFieldViewHeight: CGFloat = 44
    static let textFieldViewRadius: CGFloat = 12
    static let addButtonPaddingTop: CGFloat = 35
    static let cancelButtonPaddingTop: CGFloat = 10
}

final class OtherCategory: UIViewController {
    
// MARK: - Properties
    
    weak var delegate: OtherCategoryViewControllerDelegate?
    private lazy var alertView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .white
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Другое"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .blackTitle
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGray
        view.layer.cornerRadius = Constants.textFieldViewRadius
        return view
    }()
    private lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = .blackTitle
        tf.backgroundColor = .backgroundLightGray
        tf.becomeFirstResponder()
        tf.delegate = self
        return tf
    }()
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Добавить", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.layer.cornerRadius = Constants.buttonRadius
        btn.backgroundColor = .lockButton
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
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
    private var alertViewConstraint: NSLayoutConstraint?
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var dimmedView = UIVisualEffectView(effect: blurEffect)
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
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
            make.width.equalTo(Constants.width)
            make.height.equalTo(Constants.height)
        }
        alertViewConstraint = alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        alertViewConstraint?.isActive = true
        modalPresentationStyle = .overCurrentContext
        
        alertView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.titlePaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        
        alertView.addSubview(textFieldView)
        textFieldView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.textFieldViewPaddingTop)
            make.width.equalTo(Constants.textFieldViewWidth)
            make.height.equalTo(Constants.textFieldViewHeight)
            make.centerX.equalToSuperview()
        }
        
        textFieldView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        alertView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(Constants.addButtonPaddingTop)
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
            make.centerX.equalToSuperview()
        }
        
        alertView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(Constants.cancelButtonPaddingTop)
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
            make.centerX.equalToSuperview()
        }
    }
    
// MARK: - Selectors
    
    @objc private func handleAddButton() {
        delegate?.addOther()
    }
    
    @objc private func handleCancelButton() {
        delegate?.cancel()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            alertViewConstraint?.constant = -keyboardHeight / 3
            view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate

extension OtherCategory: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if titleTextField.text != "" {
            addButton.layer.shadowColor = UIColor.applyButton.cgColor
            addButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            addButton.layer.shadowOpacity = 0.7
            addButton.layer.shadowRadius = 4
            addButton.layer.masksToBounds = false
            addButton.setTitleColor(UIColor.white, for: .normal)
            addButton.isEnabled = true
            addButton.backgroundColor = .applyButton
        } else {
            addButton.layer.shadowRadius = 0
            addButton.layer.shadowOffset = CGSize(width: 0, height: 0)
            addButton.setTitleColor(UIColor.gray, for: .normal)
            addButton.isEnabled = false
            addButton.backgroundColor = .lockButton
        }
        return true
    }
}

//
//  AddTransactionViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 27.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let detailPaddingTop: CGFloat = 10
    static let detailViewHeight: CGFloat = 224
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let dividerHeight: CGFloat = 0.8
    static let addButtonHeight: CGFloat = 54
    static let addButtonRadius: CGFloat = 12
    static let addButtonPaddingBottom: CGFloat = 12
}

final class AddTransactionViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: AddTransactionOutput
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "chevron-left"), for: .normal)
        btn.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return btn
    }()
    private lazy var detailTransactionView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var typeView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTypeView))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var typeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "plus")
        return iv
    }()
    private lazy var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите категорию"
        label.font = UIFont(name: "MontserratRoman-Medium", size: 16)
        return label
    }()
    private lazy var choiceTypeImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "chevron-down")
        return iv
    }()
    private lazy var dividerTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGray
        return view
    }()
    private lazy var dividerBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGray
        return view
    }()
    
    private lazy var commentTextFiled: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.placeholder = "Комментарий"
        return tf
    }()

    private lazy var amoutTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Сумма"
        tf.keyboardType = .numberPad
        tf.delegate = self
        tf.font = UIFont(name: "MontserratRoman-Medium", size: 16)
        return tf
    }()
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = Constants.addButtonRadius
        btn.setTitleColor(.lockButtonTitle, for: .normal)
        btn.backgroundColor = .lockButton
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return btn
    }()
    private var buttomConstraint: NSLayoutConstraint?
    
// MARK: - Lifecycle
    
    init(output: AddTransactionOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        output.viewIsReady()
        configureUI()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureNavigationItem()
        configureDetailView()
        configureComment()
        configureAmountView()
        configureAddButton()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        view.backgroundColor = .backgroundLightGray
    }
    
    private func configureNavigationItem() {
        let leftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func configureDetailView() {
        view.addSubview(detailTransactionView)
        detailTransactionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.detailPaddingTop)
            make.width.equalToSuperview()
            make.height.equalTo(Constants.detailViewHeight)
        }
        
        detailTransactionView.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.detailViewHeight / 3)
        }
        
        detailTransactionView.addSubview(typeImageView)
        typeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.verticalPadding)
        }
        
        detailTransactionView.addSubview(typeTitleLabel)
        typeTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeImageView.snp.trailing).offset(Constants.horizontalPadding)
            make.centerY.equalTo(typeImageView.snp.centerY)
        }
        
        detailTransactionView.addSubview(choiceTypeImage)
        choiceTypeImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.centerY.equalTo(typeImageView.snp.centerY)
        }
    }
    
    private func configureComment() {
        detailTransactionView.addSubview(dividerTopView)
        dividerTopView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(typeImageView.snp.bottom).offset(Constants.verticalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.dividerHeight)
        }
        
        detailTransactionView.addSubview(commentTextFiled)
        commentTextFiled.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(dividerTopView.snp.bottom)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.detailViewHeight / 3)
        }
        
        detailTransactionView.addSubview(dividerBottomView)
        dividerBottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(commentTextFiled.snp.bottom)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.dividerHeight)
        }
    }
    
    private func configureAmountView() {
        detailTransactionView.addSubview(amoutTextField)
        amoutTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(dividerBottomView.snp.bottom)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.detailViewHeight / 3)
        }
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.addButtonHeight)
        }
        buttomConstraint = addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.addButtonPaddingBottom)
        buttomConstraint?.isActive = true
    }
    
    private func checkButtonStatus() {
        if typeTitleLabel.text != "Выберите категорию" &&
            commentTextFiled.text != "" &&
            amoutTextField.text != "" {
            addButton.setTitleColor(.white, for: .normal)
            addButton.isEnabled = true
        } else {
            addButton.setTitleColor(.lockButtonTitle, for: .normal)
            addButton.isEnabled = false
        }
        if addButton.currentTitle == "Добавить доход" {
            viewSetUp(isRevenue: true)
        } else {
            viewSetUp(isRevenue: false)
        }
    }
    
    internal func viewSetUp(isRevenue: Bool) {
        if isRevenue {
            navigationItem.title = "Добавление дохода"
            addButton.setTitle("Добавить доход", for: .normal)
            addButton.backgroundColor = addButton.isEnabled ? .applyButton : .lockButton
        } else {
            navigationItem.title = "Добавление расхода"
            addButton.setTitle("Добавить расход", for: .normal)
            addButton.backgroundColor = addButton.isEnabled ? .deleteButton : .lockButton
        }
    }
    
// MARK: - Helpers
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func handleTypeView() {
        output.showChoiceCategory()
    }
    
    @objc private func handleAddButton() {
        output.saveTransaction(comment: commentTextFiled.text, amount: amoutTextField.text)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            buttomConstraint?.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }
}

// MARK: - AddTransactionInput

extension AddTransactionViewController: AddTranactionInput {
    func showCategory(_ category: TransactionCategory) {
        typeImageView.image = UIImage(named: category.image)
        typeTitleLabel.text = category.title
        checkButtonStatus()
    }
    
    func dismissView() {
        handleBackButton()
    }
    
    func setUp(isRevenue: Bool) {
        viewSetUp(isRevenue: isRevenue)
    }
}

// MARK: - UITextFieldDelegate

extension AddTransactionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkButtonStatus()
    }
}

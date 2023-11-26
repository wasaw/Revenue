//
//  DetailedTransactionViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let detailPaddingTop: CGFloat = 10
    static let detailViewHeight: CGFloat = 224
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let dividerHeight: CGFloat = 0.8
    static let saveButtonHeight: CGFloat = 54
    static let saveButtonRadius: CGFloat = 12
}

final class DetailedTransactionViewController: UIViewController {
    
// MARK: - Properties
    
    private var output: DetailedTransactionOutput
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "trash"), for: .normal)
        btn.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        return btn
    }()
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
        return iv
    }()
    private lazy var typeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
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
    
    private lazy var amountTitleLabel: UITextField = {
        let label = UITextField()
        label.text = "Сумма"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var amoutTextField: UITextField = {
        let tf = UITextField()
        tf.becomeFirstResponder()
        tf.keyboardType = .numberPad
        tf.delegate = self
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = Constants.saveButtonRadius
        btn.setTitle("Cохранить", for: .normal)
        btn.setTitleColor(.lockButtonTitle, for: .normal)
        btn.backgroundColor = .lockButton
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return btn
    }()
    
// MARK: - Lifecycle
    
    init(output: DetailedTransactionOutput) {
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
        view.backgroundColor = .backgroundLightGray
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureNavigationItem()
        configureDetailView()
        configureComment()
        configureAmountView()
        
        view.addSubview(saveButton)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWilLShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Детали"

        let rightBarButton = UIBarButtonItem(customView: deleteButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
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
        detailTransactionView.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(dividerBottomView.snp.bottom).offset(Constants.verticalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        
        detailTransactionView.addSubview(amoutTextField)
        amoutTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
        }
    }
        
// MARK: - Selectors
    
    @objc private func handleDeleteButton() {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите удалить данную транзакцию", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить", style: .default)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func handleTypeView() {
        output.showChoiceCategory()
    }
    
    @objc private func keyboardWilLShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            view.addSubview(saveButton)
            saveButton.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(Constants.horizontalPadding)
                make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
                make.bottom.equalToSuperview().offset(-keyboardHeight - Constants.horizontalPadding)
                make.height.equalTo(Constants.saveButtonHeight)
            }
        }
    }
    
    @objc private func handleSaveButton() {
        output.saveTransaction(comment: commentTextFiled.text, amount: amoutTextField.text)
    }
}

// MARK: - DetaieldTransactionInput

extension DetailedTransactionViewController: DetailedTransactionInput {
    func showTransaction(_ transaction: Transaction) {
        typeImageView.image = UIImage(named: transaction.category.image)
        typeTitleLabel.text = transaction.category.title
        commentTextFiled.text = transaction.comment
        amoutTextField.text = String(transaction.amount) + "c"
    }
    
    func turnOnSaveButton() {
        saveButton.isEnabled = true
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .applyButton
    }
    
    func dismiss() {
        handleBackButton()
    }
}

// MARK: - UITextFieldDelegate

extension DetailedTransactionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == commentTextFiled {
            turnOnSaveButton()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == commentTextFiled && (commentTextFiled.text == ""){
            saveButton.setTitleColor(.lockButtonTitle, for: .normal)
            saveButton.backgroundColor = .lockButton
            saveButton.isEnabled = false
        }
        if textField == amoutTextField {
            output.checkAmountChanges(amoutTextField.text)
        }
    }
}

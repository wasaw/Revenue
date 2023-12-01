//
//  SelectionDateViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 01.12.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
    static let addButtonRadius: CGFloat = 12
    static let addButtonHeight: CGFloat = 54
    static let addButtonPaddingBottom: CGFloat = 12
    static let dateViewHeight: CGFloat = 74
    static let stackViewPaddingTop: CGFloat = 10
    static let separatorViewHeight: CGFloat = 0.8
}

final class SelectionDateViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: SelectionDateOutput
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "chevron-left"), for: .normal)
        btn.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return btn
    }()
    private lazy var startDateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStartDate))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var startDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Дата начала"
        return tf
    }()
    private lazy var endDateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var endDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Дата конца"
        return tf
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGray
        return view
    }()
    private lazy var dateView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = Constants.addButtonRadius
        btn.setTitle("Добавить доход", for: .normal)
        btn.setTitleColor(.lockButtonTitle, for: .normal)
        btn.backgroundColor = .lockButton
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return btn
    }()
    private var buttomConstraint: NSLayoutConstraint?
    
// MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    init(output: SelectionDateOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureNavigationItem()
        configureAddButton()
        configureStackView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        view.backgroundColor = .backgroundLightGray
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Выбор периода"
        
        let leftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButton
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
    
    private func configureStackView() {
        startDateView.addSubview(startDateTextField)
        startDateView.snp.makeConstraints { make in
            make.height.equalTo(Constants.dateViewHeight)
        }
        startDateTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        endDateView.addSubview(endDateTextField)
        endDateView.snp.makeConstraints { make in
            make.height.equalTo(Constants.dateViewHeight)
        }
        endDateTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        let stackView = UIStackView(arrangedSubviews: [startDateView, separatorView, endDateView])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.stackViewPaddingTop)
            make.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(stackView.snp.leading)
            make.height.equalTo(Constants.separatorViewHeight)
            make.trailing.equalTo(stackView.snp.trailing)
        }
    }
    
    private func checkButtonStatus() {
//        if typeTitleLabel.text != "Выберите категорию" &&
//            commentTextFiled.text != "" &&
//            amoutTextField.text != "" {
//            addButton.setTitleColor(.white, for: .normal)
//            addButton.backgroundColor = .applyButton
//            addButton.isEnabled = true
//        } else {
//            addButton.setTitleColor(.lockButtonTitle, for: .normal)
//            addButton.backgroundColor = .lockButton
//            addButton.isEnabled = false
//        }
    }
    
// MARK: - Helpers
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func handleAddButton() {
//        output.saveTransaction(comment: commentTextFiled.text, amount: amoutTextField.text)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            buttomConstraint?.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }
    
    @objc private func handleStartDate() {
        let vc = DatePickerViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

// MARK: - SelectionDateInput

extension SelectionDateViewController: SelectionDateInput {
    
}

// MARK: - UITextFieldDelegate

//extension AddTransactionViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
////        checkButtonStatus()
//    }
//}

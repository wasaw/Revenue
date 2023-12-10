//
//  EditSelectedDetail.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let detailPaddingTop: CGFloat = 10
    static let detailViewHeight: CGFloat = 74
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let dividerHeight: CGFloat = 0.8
    static let saveButtonHeight: CGFloat = 54
    static let saveButtonRadius: CGFloat = 12
}

final class EditSelectedDetail: UIViewController {
    
// MARK: - Properties
        
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
    private lazy var amountTitleLabel: UITextField = {
        let label = UITextField()
        label.text = "Сумма"
        label.font = UIFont(name: "MontserratRoman-Light", size: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var amoutTextField: UITextField = {
        let tf = UITextField()
        tf.becomeFirstResponder()
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf.font = UIFont(name: "MontserratRoman-Medium", size: 16)
        return tf
    }()
    private let contributionsService = ContributionsService(coreData: CoreDataService())
    private let goalItem: GoalDetilsItem
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    init(goalItem: GoalDetilsItem) {
        self.goalItem = goalItem
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        view.backgroundColor = .backgroundLightGray
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureNavigationItem()
        configureDetailView()
        configureAmountView()
        
        amoutTextField.text = goalItem.amountForOutput
        view.addSubview(saveButton)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWilLShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    private func configureNavigationItem() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        navigationItem.title = "Взнос на " + formatter.string(from: goalItem.date)

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
    }
    
    private func configureAmountView() {
        detailTransactionView.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.verticalPadding)
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
        let vc = DeleteViewController(titleAlert: "Вы действительно хотите удалить данный взнос?")
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func handleTypeView() {
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
        var lastCharacter = amoutTextField.text?.last
        guard var text = amoutTextField.text else { return }
        while lastCharacter == " " || lastCharacter == "c" {
            _ = text.popLast()
            lastCharacter = text.last
        }
        let trimmedString = text.replacingOccurrences(of: " ", with: "")
        guard let amount = Double(trimmedString) else { return }
        contributionsService.saveContribution(Contribution(id: UUID(), amount: amount, date: Date(), goal: goalItem.goalId))
        contributionsService.delete(for: goalItem.detailId)
        handleBackButton()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveButton.backgroundColor = .applyButton
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.isEnabled = true
    }
}

// MARK: - DeleteViewControllerDelegate

extension EditSelectedDetail: DeleteViewControllerDelegate {
    func delete() {
        dismiss(animated: true)
        handleBackButton()
        contributionsService.delete(for: goalItem.detailId)
        NotificationCenter.default.post(Notification(name: .delete))
    }
    
    func cancel() {
        dismiss(animated: true)
    }
}

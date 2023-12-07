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
    static let stackViewPaddingTop: CGFloat = 14
    static let separatorViewHeight: CGFloat = 0.8
    static let titlePaddingTop: CGFloat = 8
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
    private lazy var startDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата начала"
        label.font = UIFont(name: "MontserratRoman-Light", size: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var startDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Дата начала"
        return tf
    }()
    private lazy var finishDateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEndDate))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var finishDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата конца"
        label.font = UIFont(name: "MontserratRoman-Light", size: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var finishDateTextField: UITextField = {
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
        btn.setTitle("Применить", for: .normal)
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
        
        finishDateView.addSubview(finishDateTextField)
        finishDateView.snp.makeConstraints { make in
            make.height.equalTo(Constants.dateViewHeight)
        }
        finishDateTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        let stackView = UIStackView(arrangedSubviews: [startDateView, separatorView, finishDateView])
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
        
        view.addSubview(startDateTitleLabel)
        startDateTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(stackView.snp.top).offset(Constants.titlePaddingTop)
        }
        startDateTitleLabel.layer.opacity = 0
        
        view.addSubview(finishDateTitleLabel)
        finishDateTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(separatorView.snp.bottom).offset(Constants.titlePaddingTop)
        }
        finishDateTitleLabel.layer.opacity = 0
    }
    
    private func checkButtonStatus() {
        if startDateTextField.text != "" && finishDateTextField.text != "" {
            addButton.backgroundColor = .applyButton
            addButton.setTitleColor(.white, for: .normal)
            addButton.isEnabled = true
        } else {
            addButton.backgroundColor = .lockButton
            addButton.setTitleColor(.lockButtonTitle, for: .normal)
            addButton.isEnabled = false
        }
    }
    
    private func showTitle(isStart: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            if isStart {
                self?.startDateTitleLabel.layer.opacity = 1
            } else {
                self?.finishDateTitleLabel.layer.opacity = 1
            }
        }
    }
    
// MARK: - Helpers
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func handleAddButton() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        guard let startString = startDateTextField.text,
              let finishString = finishDateTextField.text,
              let start = formatter.date(from: startString),
              let finish = formatter.date(from: finishString) else { return }
        output.save(start: start, finish: finish)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            buttomConstraint?.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }
    
    @objc private func handleStartDate() {
        let vc = DatePickerViewController(title: "С какого числа")
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func handleEndDate() {
        let vc = DatePickerViewController(title: "По какое число")
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - SelectionDateInput

extension SelectionDateViewController: SelectionDateInput {
    
}

// MARK: - DatePicketiewDelegate

extension SelectionDateViewController: DatePickerViewControllerDelegate {
    func startDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        startDateTextField.text = formatter.string(from: date)
        UserDefaults.standard.set(date, forKey: DefaultsValues.startDate)
        checkButtonStatus()
        showTitle(isStart: true)
    }
    
    func finishDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        finishDateTextField.text = formatter.string(from: date)
        UserDefaults.standard.set(date, forKey: DefaultsValues.finishDate)
        checkButtonStatus()
        showTitle(isStart: false)
    }
}

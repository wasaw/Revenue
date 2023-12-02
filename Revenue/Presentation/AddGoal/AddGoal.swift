//
//  AddGoal.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let goalViewPaddingTop: CGFloat = 8
    static let goalViewHeight: CGFloat = 154
    static let goalImageViewPaddingTop: CGFloat = 16
    static let goalLabelPaddingTop: CGFloat = 16
    static let goalStackViewHeight: CGFloat = 224
    static let rowHeight: CGFloat = 74
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 18
    static let dividerHeight: CGFloat = 0.8
    static let addButtonHeight: CGFloat = 54
    static let addButtonRadius: CGFloat = 12
    static let addButtonPaddingBottom: CGFloat = 12
}

final class AddGoal: UIViewController {
    
// MARK: - Properties
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "chevron-left"), for: .normal)
        btn.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return btn
    }()
    private lazy var goalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGoalView))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        ip.allowsEditing = true
        return ip
    }()
    private lazy var goalImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "image-add")
        return iv
    }()
    private lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить изображение"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var titleTextView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Название цели"
        tf.textColor = .titleColorGray
        return tf
    }()
    private lazy var timeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTimeView))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок выполнения цели"
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var goalAmountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var goalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Целевая сумма"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var goalAmountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "0c"
        return tf
    }()
    private lazy var currentAmountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var currentAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Целевая сумма"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var currentAmountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "0c"
        return tf
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
    private lazy var dividerVerticalView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGray
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
    
// MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.barStyle = .default
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleHideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backButtonTitle = ""
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Добавление цели"
        
        let leftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButton
        
        view.addSubview(goalView)
        goalView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.goalViewPaddingTop)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.goalViewHeight)
        }
        goalView.addSubview(goalImageView)
        goalImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.goalImageViewPaddingTop)
            make.centerX.equalToSuperview()
        }
        goalView.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(goalImageView.snp.bottom).offset(Constants.goalLabelPaddingTop)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(titleTextView)
        titleTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(goalView.snp.bottom).offset(Constants.goalViewPaddingTop)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.rowHeight)
        }
        titleTextView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(dividerTopView)
        dividerTopView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(titleTextView.snp.bottom)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.dividerHeight)
        }
        
        view.addSubview(timeView)
        timeView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dividerTopView.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.rowHeight)
        }
        timeView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(dividerBottomView)
        dividerBottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(timeView.snp.bottom)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.dividerHeight)
        }
        
        view.addSubview(dividerVerticalView)
        dividerVerticalView.snp.makeConstraints { make in
            make.top.equalTo(dividerBottomView.snp.bottom)
            make.width.equalTo(Constants.dividerHeight)
            make.height.equalTo(Constants.rowHeight)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(goalAmountView)
        goalAmountView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dividerBottomView.snp.bottom)
            make.trailing.equalTo(dividerVerticalView.snp.leading)
            make.height.equalTo(Constants.rowHeight)
        }
        goalAmountView.addSubview(goalAmountLabel)
        goalAmountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.centerX.equalToSuperview()
        }
        goalAmountView.addSubview(goalAmountTextField)
        goalAmountTextField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(currentAmountView)
        currentAmountView.snp.makeConstraints { make in
            make.leading.equalTo(dividerVerticalView.snp.trailing)
            make.top.equalTo(dividerBottomView.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.rowHeight)
        }
        currentAmountView.addSubview(currentAmountLabel)
        currentAmountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.centerX.equalToSuperview()
        }
        currentAmountView.addSubview(currentAmountTextField)
        currentAmountTextField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Constants.verticalPadding)
            make.height.equalTo(Constants.addButtonHeight)
        }
 
        view.backgroundColor = .backgroundLightGray
    }
    
// MARK: - Helpers
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func handleAddButton() {
        
    }
    
    @objc private func handleTimeView() {
        let vc = DatePickerViewController(title: "Срок выполнения цели")
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func handleGoalView() {
        present(imagePicker, animated: true)
    }
    
    @objc private func handleHideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - DatePickerViewControllerDelegate

extension AddGoal: DatePickerViewControllerDelegate {
    func startDate(_ date: String) {
    }
    
    func endDate(_ date: String) {
        timeLabel.text = date
    }
}

// MARK: - UIImagePickerControllerDelegate

extension AddGoal: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        goalView.backgroundColor = UIColor(patternImage: image)
        dismiss(animated: true)
    }
}

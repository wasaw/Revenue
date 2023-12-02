//
//  GoalDetailsViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit

private enum Constants {
    static let detailPaddingTop: CGFloat = 10
    static let detailViewHeight: CGFloat = 450
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 16
    static let dividerHeight: CGFloat = 0.8
    static let saveButtonHeight: CGFloat = 54
    static let saveButtonRadius: CGFloat = 12
    static let saveButtonPaddingBottom: CGFloat = 25
    static let cornerRadius: CGFloat = 16
    static let valueLabelPadding: CGFloat = 5
}

final class GoalDetailsViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: GoalDetailsOutput
    
    private lazy var detailButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "dot-horizontal"), for: .normal)
        btn.addTarget(self, action: #selector(handleDetailButton), for: .touchUpInside)
        return btn
    }()
    private lazy var backButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "chevron-left"), for: .normal)
        btn.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return btn
    }()
    
    private lazy var logoIV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "goal1")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.text = "Накопить на ZEEKR из авто салона"
        label.font = UIFont.systemFont(ofSize: 24)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    private lazy var goalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Целевая сумма"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var periodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.text = "4000000c"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    private lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.text = "21.12.2024"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    private lazy var goalResultLabel: UILabel = {
        let label = UILabel()
        label.text = "4 000 000 с из 4 000 000 с"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var goalPersentLabel: UILabel = {
        let label = UILabel()
        label.text = "100%"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .bottomUnderline
        progressView.clipsToBounds = true
        return progressView
    }()
    private lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.text = "История взносов"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var detailTableButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Подробнее", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(handleDetailTable), for: .touchUpInside)
        return btn
    }()
    
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = GoalDetailsDataSource(tableView)
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = Constants.saveButtonRadius
        btn.setTitle("Добавить взнос", for: .normal)
        btn.setTitleColor(.lockButtonTitle, for: .normal)
        btn.backgroundColor = .lockButton
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return btn
    }()
    
// MARK: - Lifecycle
    
    init(output: GoalDetailsOutput) {
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
        
        UIView.animate(withDuration: 0.3) {
           self.containerViewBottomConstraint?.constant = 0
           self.view.layoutIfNeeded()
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureNavigationItem()
        configureLogoView()
        configureContainer()
        configureTitle()
        configureContainerContent()
        configureTableView()
        configureSaveButton()
        
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "Детали"

        let rightBarButton = UIBarButtonItem(customView: detailButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func configureLogoView() {
        view.addSubview(logoIV)
        logoIV.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalToSuperview()
            make.height.equalTo(view.frame.height - Constants.detailViewHeight)
        }
    }
    
    private func configureContainer() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
                
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: Constants.detailViewHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.detailViewHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    private func configureTitle() {
        view.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalTo(containerView.snp.top).offset(-Constants.verticalPadding)
        }
    }
    
    private func configureContainerContent() {
        containerView.addSubview(goalTitleLabel)
        goalTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.verticalPadding)
        }
        
        containerView.addSubview(periodTitleLabel)
        periodTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.verticalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        
        containerView.addSubview(goalLabel)
        goalLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(Constants.valueLabelPadding)
        }
        
        containerView.addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(periodTitleLabel.snp.bottom).offset(Constants.valueLabelPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        
        containerView.addSubview(goalResultLabel)
        goalResultLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(goalLabel.snp.bottom).offset(Constants.verticalPadding)
        }
        
        containerView.addSubview(goalPersentLabel)
        goalPersentLabel.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(Constants.verticalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        
        containerView.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(goalResultLabel.snp.bottom)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
        progressBar.setProgress(0.8, animated: true)
        
        containerView.addSubview(historyLabel)
        historyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(progressBar.snp.bottom).offset(Constants.verticalPadding)
        }
        
        containerView.addSubview(detailTableButton)
        detailTableButton.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom).offset(Constants.detailPaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
        }
    }
    
    private func configureTableView() {
        containerView.addSubview(tableView)
        tableView.register(GoalDetailsCell.self, forCellReuseIdentifier: GoalDetailsCell.reuseIdentifire)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(historyLabel.snp.bottom).offset(Constants.verticalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview()
        }
        tableView.backgroundColor = .white
        setupDataSource([GoalDetilsItem(date: Date(), amount: "")])
    }
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Constants.saveButtonPaddingBottom)
            make.height.equalTo(Constants.saveButtonHeight)
        }
    }
    
    func setupDataSource(_ items: [GoalDetilsItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(GoalDetailsSections.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }

// MARK: - Selectors
    
    @objc private func handleDetailButton() {
        let vc = GoalDetailsBottomViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc private func handleBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func handleSaveButton() {
//        output.saveTransaction(comment: commentTextFiled.text, amount: amoutTextField.text)
    }
    
    @objc private func handleDetailTable() {
        let vc = ShowAllDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - GoalDetailsInput

extension GoalDetailsViewController: GoalDetailsInput {
    
}
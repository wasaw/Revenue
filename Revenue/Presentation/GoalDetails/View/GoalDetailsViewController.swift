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
    static let addButtonHeight: CGFloat = 54
    static let addButtonRadius: CGFloat = 12
    static let addButtonPaddingBottom: CGFloat = 45
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
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Bold", size: 24)
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
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 84
    private var currentContainerHeight: CGFloat = Constants.detailViewHeight
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    private lazy var goalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Целевая сумма"
        label.font = UIFont(name: "MontserratRoman-Light", size: 14)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var periodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок"
        label.font = UIFont(name: "MontserratRoman-Light", size: 14)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var goalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Bold", size: 24)
        label.textColor = .black
        return label
    }()
    private lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Bold", size: 24)
        label.textColor = .black
        return label
    }()
    private lazy var goalResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Light", size: 12)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var goalPersentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MontserratRoman-Light", size: 12)
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
        label.font = UIFont(name: "MontserratRoman-Bold", size: 18)
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
    
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = Constants.addButtonRadius
        btn.setTitle("Добавить взнос", for: .normal)
        btn.setTitleColor(.lockButtonTitle, for: .normal)
        btn.backgroundColor = .lockButton
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
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
        setupPanGestire()
        output.viewIsReady()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureNavigationItem()
        configureLogoView()
        configureContainer()
        configureTitle()
        configureContainerContent()
        configureTableView()
        configureAddButton()
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
        tableView.delegate = self
        tableView.backgroundColor = .white
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Constants.addButtonPaddingBottom)
            make.height.equalTo(Constants.addButtonHeight)
        }
    }
    
    private func setupPanGestire() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture: )))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    private func setupDataSource(_ items: [GoalDetailsItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(GoalDetailsSections.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

// MARK: - Selectors
    
    @objc private func handleDetailButton() {
        let vc = GoalDetailsBottomViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc private func handleBackButton() {
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func handleAddButton() {
        output.showAddDetail()
    }
    
    @objc private func handleDetailTable() {
        output.showAllDetails()
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown  = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < Constants.detailViewHeight {
                animateContainerHeight(Constants.detailViewHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(Constants.detailViewHeight)
            }
            else if newHeight > Constants.detailViewHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
}

// MARK: - GoalDetailsInput

extension GoalDetailsViewController: GoalDetailsInput {
    func setData(_ items: [GoalDetailsItem]) {
        setupDataSource(items)
    }
    
    func setGoalData(_ item: Goal) {
        titleLable.text = item.title
        goalLabel.text = item.amountForOutput
        goalResultLabel.text = String(format: "%.0f", item.introduced) + " с из " + String(format: "%.0f", item.total) + "с"
        let persent: Float = Float(item.introduced / item.total)
        progressBar.setProgress(persent, animated: true)
        goalPersentLabel.text = String(format: "%.0f", persent * 100) + "%"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        periodLabel.text = formatter.string(from: item.date)
        logoIV.image = item.image

        if item.isFinished {
            addButton.backgroundColor = .lockButton
            addButton.setTitleColor(.lockButtonTitle, for: .normal)
            addButton.isEnabled = false
        } else {
            addButton.backgroundColor = .applyButton
            addButton.setTitleColor(.white, for: .normal)
            addButton.isEnabled = true
        }
    }
    
    func showPopUp(_ title: PopUpTitle) {
        let vc = PopUp(title)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true) { [weak self] in
            sleep(2)
            self?.dismiss(animated: true)
        }
    }
}

// MARK: - GoalDetailsBottomViewControllerDelegate

extension GoalDetailsViewController: GoalDetailsBottomViewControllerDelegate {
    func deleteItem() {
        navigationController?.dismiss(animated: true)
        output.delete()
        handleBackButton()
    }
    
    func showEdit() {
        output.showEdit()
    }
}

// MARK: - UITableViewDelegate

extension GoalDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

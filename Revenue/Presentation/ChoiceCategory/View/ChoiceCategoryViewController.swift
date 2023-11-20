//
//  ChoiceCategoryViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let cornerRadius: CGFloat = 16
    static let defaultHeight: CGFloat = 600
    static let horizontalPadding: CGFloat = 16
    static let segmentPaddingTop: CGFloat = 36
    static let segmentHeight: CGFloat = 38
    static let tablePaddingTop: CGFloat = 16
    static let edgeLineViewPaddingTop: CGFloat = 8
    static let edgeLineViewWidth: CGFloat = 50
    static let edgeLineViewHeight: CGFloat = 4
}

final class ChoiceCategoryViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ChoiceOutput
    
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var dimmedView = UIVisualEffectView(effect: blurEffect)
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    private lazy var segmentItems = ["Доходы", "Расходы"]
    private lazy var segmentController: UISegmentedControl = {
        let sc = UISegmentedControl(items: segmentItems)
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([.foregroundColor: UIColor.lightGray,
                                   .font: UIFont.systemFont(ofSize: 16)], for: .normal)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                   .font: UIFont.systemFont(ofSize: 16)], for: .selected)
        sc.selectedSegmentTintColor = .black
        return sc
    }()
    private lazy var edgeLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGray
        return view
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        return table
    }()
    private lazy var dataSource = ChoiceCategoryDataSource(tableView)
    
// MARK: - Lifecycle
    
    init(output: ChoiceOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
           self.containerViewBottomConstraint?.constant = 0
           self.view.layoutIfNeeded()
       }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        configureUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        dimmedView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
                
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: Constants.defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        containerView.addSubview(segmentController)
        segmentController.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.segmentPaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.segmentHeight)
        }
        
        tableView.register(ChoiceCategoryCell.self, forCellReuseIdentifier: ChoiceCategoryCell.reuseIdentifire)
        tableView.delegate = self
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(segmentController.snp.bottom).offset(Constants.tablePaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview()
        }
        
        containerView.addSubview(edgeLineView)
        edgeLineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.edgeLineViewPaddingTop)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.edgeLineViewPaddingTop)
            make.height.equalTo(Constants.edgeLineViewHeight)
        }
        
        view.backgroundColor = .clear
    }
    
    private func setupDataSource(_ items: [TableCategoryItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(TableCategorySections.allCases)
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = Constants.defaultHeight
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
// MARK: - Selectors
    
    @objc private func handleCloseAction() {
        animateDismissView()
    }
}

// MARK: - ChoiceInput

extension ChoiceCategoryViewController: ChoiceInput {
    func setCategories(_ items: [TableCategoryItem]) {
        setupDataSource(items)
    }
}

// MARK: - UITableViewDelegate

extension ChoiceCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

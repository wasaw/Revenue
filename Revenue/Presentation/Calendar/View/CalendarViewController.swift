//
//  CalendarViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 30.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let cornerRadius: CGFloat = 30
    static let defaultHeight: CGFloat = 350
    static let horizontalPadding: CGFloat = 16
    static let titlePaddingTop: CGFloat = 40
    static let tablePaddingTop: CGFloat = 15
    static let tablePaddingBottom: CGFloat = 40
    static let edgeLineViewPaddingTop: CGFloat = 8
    static let edgeLineViewWidth: CGFloat = 50
    static let edgeLineViewHeight: CGFloat = 4
}

final class CalendarViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: CalendarOutput
    
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var dimmedView = UIVisualEffectView(effect: blurEffect)
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Период"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    private lazy var edgeLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGray
        return view
    }()
    private lazy var dataSource = CalendarDataSource(tableView)
    private lazy var tableView = UITableView(frame: .zero)
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
// MARK: - Lifecycle
    
    init(output: CalendarOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
           self.containerViewBottomConstraint?.constant = 0
           self.view.layoutIfNeeded()
       }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        configureUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseAction))
        view.addGestureRecognizer(tapGesture)
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
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
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.titlePaddingTop)
        }
        
        containerView.addSubview(tableView)
        tableView.register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.reuseIdentifire)
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.tablePaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview().offset(-Constants.tablePaddingBottom)
        }
        
        containerView.addSubview(edgeLineView)
        edgeLineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.edgeLineViewPaddingTop)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.edgeLineViewWidth)
            make.height.equalTo(Constants.edgeLineViewHeight)
        }
    }
    
    private func setupDataSource(_ items: [CalendarItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(CalendarSections.allCases)
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
            self.dismiss(animated: false) {
            }
        }
    }
    
// MARK: - Selecters
    
    @objc private func handleCloseAction() {
        animateDismissView()
    }
}

// MARK: - CalendatInput

extension CalendarViewController: CalendarInput {
    func setCalendar(_ items: [CalendarItem]) {
        setupDataSource(items)
    }
}

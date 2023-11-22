//
//  HomeViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let segmentContainerPaddingTop: CGFloat = 8
    static let segmentContainerViewHeight: CGFloat = 45
    static let segmentedControllerHeight: CGFloat = 40
    static let bottomUnderlineViewBottomPadding: CGFloat = 4
    static let bottomUnderlineViewHeight: CGFloat = 2
    static let horizontalPadding: CGFloat = 16
    static let calendarRadius: CGFloat = 23
    static let homeViewPaddingTop: CGFloat = bottomUnderlineViewBottomPadding + bottomUnderlineViewHeight
}

final class HomeViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: HomeOutput
    
    private lazy var calendarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.calendarRadius
        view.backgroundColor = .calendarBackground
        return view
    }()
    private lazy var calendarIV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "calendar")
        return iv
    }()
    private lazy var calendarLabel: UILabel = {
        let label = UILabel()
        label.text = "с 01.07.2023 по 01.08.2023"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var segmentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var segmentItems = ["Остаток",
                                     "Доходы",
                                     "Расходы",
                                     "Цели"]
    private lazy var segmentedController: UISegmentedControl = {
        let sc = UISegmentedControl(items: segmentItems)
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([.foregroundColor: UIColor.lightGray,
                                   .font: UIFont.systemFont(ofSize: 16)], for: .normal)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                   .font: UIFont.systemFont(ofSize: 16)], for: .selected)
        sc.selectedSegmentTintColor = .clear
        sc.tintColor = .clear
        sc.backgroundColor = .clear
        sc.addTarget(self, action: #selector(segmentedControlValueChange), for: .valueChanged)
        return sc
    }()
    private lazy var bottomUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .bottomUnderline
        return view
    }()
    private lazy var remainsView: HomeRemainsView = {
        let view = HomeRemainsView()
        return view
    }()
    private lazy var revenueView: HomeRevenueView = {
        let view = HomeRevenueView()
        return view
    }()
    private lazy var expensesView: HomeExpensesView = {
        let view = HomeExpensesView()
        return view
    }()
    private lazy var goalsView: HomeGoalsView = {
        let view = HomeGoalsView()
        return view
    }()
    private lazy var visibleViews = [remainsView,
                                     revenueView,
                                     expensesView,
                                     goalsView]
        
// MARK: - Lifecycle
    
    init(output: HomeOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.barStyle = .black
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .background
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        configureCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewIsReady()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backButtonTitle = ""
       
        calendarView.removeFromSuperview()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configureCalendar()
        configureSegmentController()
        configureRemainsView()
        configureRevenueView()
        configureExpensesView()
        configureGoalsView()

        let backImage = UIImage(named: "chevron-left")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        view.backgroundColor = .background
    }
    
    private func configureCalendar() {
        navigationController?.navigationBar.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.bottom.equalToSuperview()
        }
        
        calendarView.addSubview(calendarIV)
        calendarIV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        calendarView.addSubview(calendarLabel)
        calendarLabel.snp.makeConstraints { make in
            make.leading.equalTo(calendarIV.snp.trailing).offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
    }
    private func configureSegmentController() {
        view.addSubview(segmentContainerView)
        segmentContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.segmentContainerPaddingTop)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.segmentContainerViewHeight)
        }
        
        segmentContainerView.addSubview(segmentedController)
        segmentedController.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.segmentedControllerHeight)
            make.centerY.equalToSuperview()
        }
        
        segmentContainerView.addSubview(bottomUnderlineView)
        bottomUnderlineView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(Constants.bottomUnderlineViewBottomPadding)
            make.height.equalTo(Constants.bottomUnderlineViewHeight)
            make.width.equalToSuperview().multipliedBy(1 / CGFloat(segmentedController.numberOfSegments))
        }
    }
    
    private func configureRemainsView() {
        view.addSubview(remainsView)
        remainsView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(segmentContainerView.snp.bottom).offset(Constants.homeViewPaddingTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        remainsView.delegate = self
    }
    private func configureRevenueView() {
        view.addSubview(revenueView)
        revenueView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(segmentContainerView.snp.bottom).offset(Constants.homeViewPaddingTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        revenueView.isHidden = true
    }
    private func configureExpensesView() {
        view.addSubview(expensesView)
        expensesView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(segmentContainerView.snp.bottom).offset(Constants.homeViewPaddingTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        expensesView.isHidden = true
    }
    private func configureGoalsView() {
        view.addSubview(goalsView)
        goalsView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(segmentContainerView.snp.bottom).offset(Constants.homeViewPaddingTop)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        goalsView.isHidden = true
    }
    
    private func updateVisibleView(for segmentIndex: Int) {
        visibleViews.enumerated().forEach { i, view in
            if i == segmentIndex {
                view.isHidden = false
            } else {
                view.isHidden = true
            }
        }
    }
    
// MARK: - Selecter
    
    @objc private func segmentedControlValueChange(_ sender: UISegmentedControl) {
        let segmentIndex = CGFloat(segmentedController.selectedSegmentIndex)
        let segmentWidth = segmentedController.frame.width / CGFloat(segmentedController.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.bottomUnderlineView.snp.updateConstraints({ make in
                make.leading.equalToSuperview().offset(leadingDistance)
            })
            self?.view.layoutIfNeeded()
        }
        
        updateVisibleView(for: sender.selectedSegmentIndex)
        guard let segment = Segment(rawValue: sender.selectedSegmentIndex) else { return }
        output.fetchData(for: segment)
    }
}

// MARK: - HomeInputProtocol

extension HomeViewController: HomeInputProtocol {
    func setTransactions(_ items: [HomeTransactions]) {
        remainsView.setupDataSource(items)
    }
    
    func setRevenue(_ items: [HomeRevenueItem]) {
        revenueView.setupDataSource(items)
    }
}

// MARK: - HomeRemainsViewProtocol

extension HomeViewController: HomeRemainsViewProtocol {
    func details(at index: Int, in section: Int) {
        output.showDetails(at: index, in: section)
    }
}

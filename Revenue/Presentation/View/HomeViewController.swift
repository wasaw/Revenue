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
    static let balanceViewHeight: CGFloat = 100
    static let horizontalPadding: CGFloat = 16
    static let balanceTitlePaddingTop: CGFloat = 20
    static let balanceLabelPaddingTop: CGFloat = 8
    static let calendarRadius: CGFloat = 23
}

final class HomeViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: HomeOutputProtocol
    
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
    private lazy var segmentItems = ["Остаток", "Доходы", "Расходы", "Цели"]
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
    
    private lazy var balanceView: UIView = {
        let view = UIView()
        view.backgroundColor = .balanceBanckground
        return view
    }()
    private lazy var balanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Текущий остаток"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .titleColorGray
        return label
    }()
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "110 000,89 c"
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .incomeCash
        return label
    }()

// MARK: - Lifecycle
    
    init(output: HomeOutputProtocol) {
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
        
        view.addSubview(balanceView)
        balanceView.snp.makeConstraints { make in
            make.top.equalTo(segmentContainerView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(Constants.balanceViewHeight)
        }
        
        balanceView.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalToSuperview().offset(Constants.balanceTitlePaddingTop)
        }
        
        balanceView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(Constants.balanceLabelPaddingTop)
        }
        
        view.backgroundColor = .background
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
    }
}

// MARK: - HomeInputProtocol

extension HomeViewController: HomeInputProtocol {
    
}

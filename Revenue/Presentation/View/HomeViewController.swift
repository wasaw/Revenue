//
//  HomeViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let segmentContainerViewHeight: CGFloat = 45
    static let segmentedControllerHeight: CGFloat = 40
    static let bottomUnderlineViewBottomPadding: CGFloat = 4
    static let bottomUnderlineViewHeight: CGFloat = 2
}

final class HomeViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: HomeOutputProtocol
    
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
        view.addSubview(segmentContainerView)
        
        segmentContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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

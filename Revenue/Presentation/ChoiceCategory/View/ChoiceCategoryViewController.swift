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
        
        view.backgroundColor = .clear
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
    
}

//
//  GoalDetailsBottomViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import UIKit
import SnapKit

protocol GoalDetailsBottomViewControllerDelegate: AnyObject {
    func deleteItem()
    func showEdit()
}

private enum Constants {
    static let cornerRadius: CGFloat = 30
    static let defaultHeight: CGFloat = 200
    static let horizontalPadding: CGFloat = 16
    static let titlePaddingTop: CGFloat = 40
    static let edgeLineViewPaddingTop: CGFloat = 8
    static let edgeLineViewWidth: CGFloat = 50
    static let edgeLineViewHeight: CGFloat = 4
    static let viewPaddingTop: CGFloat = 8
    static let viewHeight: CGFloat = 44
}

final class GoalDetailsBottomViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: GoalDetailsBottomViewControllerDelegate?
    
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
        label.text = "Действие"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    private lazy var edgeLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundLightGray
        return view
    }()
    private lazy var editView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEdit))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var editImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "edit")
        return iv
    }()
    private lazy var editLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактировать"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private lazy var deleteView: UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDelete))
        view.addGestureRecognizer(tap)
        return view
    }()
    private lazy var deleteImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "trashDetails")
        return iv
    }()
    private lazy var deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "Удалить"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
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
        
        containerView.addSubview(edgeLineView)
        edgeLineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.edgeLineViewPaddingTop)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.edgeLineViewWidth)
            make.height.equalTo(Constants.edgeLineViewHeight)
        }
        
        containerView.addSubview(editView)
        editView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.viewPaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.viewHeight)
        }
        editView.addSubview(editImageView)
        editImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        editView.addSubview(editLabel)
        editLabel.snp.makeConstraints { make in
            make.leading.equalTo(editImageView.snp.trailing).offset(Constants.horizontalPadding)
            make.centerY.equalTo(editImageView.snp.centerY)
        }
        
        containerView.addSubview(deleteView)
        deleteView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.top.equalTo(editView.snp.bottom).offset(Constants.viewPaddingTop)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.height.equalTo(Constants.viewHeight)
        }
        deleteView.addSubview(deleteImageView)
        deleteImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        deleteView.addSubview(deleteLabel)
        deleteLabel.snp.makeConstraints { make in
            make.leading.equalTo(deleteImageView.snp.trailing).offset(Constants.horizontalPadding)
            make.centerY.equalTo(deleteImageView.snp.centerY)
        }
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
    
    @objc private func handleDelete() {
        let vc = DeleteViewController(titleAlert: "Вы действительно хотите удалить данную цель?")
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func handleEdit() {
        handleCloseAction()
        delegate?.showEdit()
    }
}

// MARK - DeleteViewControllerDelegate

extension GoalDetailsBottomViewController: DeleteViewControllerDelegate {
    func delete() {
        delegate?.deleteItem()
        animateDismissView()
    }
    
    func cancel() {
        animateDismissView()
    }
}

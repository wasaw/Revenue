//
//  PopUp.swift
//  Revenue
//
//  Created by Александр Меренков on 05.12.2023.
//

import UIKit

enum PopUpTitle: String {
    case addIncome = "Доход добавлен"
    case addExpense = "Расход добавлен"
    case addGoal = "Цель добавлена"
    case addContributons = "Взнос добавлен"
    case deleteTransaction = "Транзакция удалена"
    case deleteGoal = "Цель удалена"
    case update = "Изменения сохранены"
}

private enum Constants {
    static let width: CGFloat = 328
    static let height: CGFloat = 44
    static let alertPaddingTop: CGFloat = 70
    static let cornerRadius: CGFloat = 12
    static let horizontalPadding: CGFloat = 12
}

final class PopUp: UIViewController {
    
// MARK: - Properties
    
    private let popUpTitle: PopUpTitle
    private lazy var alertView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .white
        return view
    }()
    private lazy var markIV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "checkmark")
        return iv
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Взнос добавлен"
        label.font = UIFont(name: "MontserratRoman-Bold", size: 14)
        return label
    }()
    
// MARK: - Lifecycle
    
    init(_ popUpTitle: PopUpTitle) {
        self.popUpTitle = popUpTitle
        
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
        view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.alertPaddingTop)
            make.width.equalTo(Constants.width)
            make.height.equalTo(Constants.height)
        }
        
        alertView.addSubview(markIV)
        markIV.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        
        alertView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(markIV.snp.trailing).offset(Constants.horizontalPadding)
            make.centerY.equalToSuperview()
        }
        titleLabel.text = popUpTitle.rawValue
    }
}

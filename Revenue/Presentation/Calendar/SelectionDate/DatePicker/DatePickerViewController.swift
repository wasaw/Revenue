//
//  DatePickerViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 01.12.2023.
//

import UIKit

protocol DatePickerViewControllerDelegate: AnyObject {
    func startDate(_ date: Date)
    func finishDate(_ date: Date)
}

private enum Constants {
    static let height: CGFloat = 334
    static let cornerRadius: CGFloat = 25
    static let horizontalPadding: CGFloat = 12
    static let dateTitleHeight: CGFloat = 60
    static let dateButtonHeigth: CGFloat = 60
}

final class DatePickerViewController: UIViewController {
    
// MARK: - Properties
    
    weak var delegate: DatePickerViewControllerDelegate?
    private lazy var dateView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    private lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()
    private lazy var dateTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    private lazy var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .wheels
        dp.datePickerMode = .date
        dp.backgroundColor = .white
        return dp
    }()
    private lazy var dateButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Готово", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .dateButton
        btn.addTarget(self, action: #selector(handleDateButton), for: .touchUpInside)
        return btn
    }()
  
    private lazy var blurEffect = UIBlurEffect(style: .dark)
    private lazy var dimmedView = UIVisualEffectView(effect: blurEffect)
    
// MARK: - Lifecycle
    
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.dateTitleLabel.text = title
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
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(dateView)
        dateView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.horizontalPadding)
            make.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.height)
        }
        modalPresentationStyle = .overCurrentContext
        
        dateView.addSubview(dateTitleView)
        dateTitleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.dateTitleHeight)
        }
        
        dateTitleView.addSubview(dateTitleLabel)
        dateTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        dateView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(dateTitleView.snp.bottom)
            make.trailing.equalToSuperview()
        }
        
        dateView.addSubview(dateButton)
        dateButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(datePicker.snp.bottom)
            make.trailing.equalToSuperview()
            make.height.equalTo(Constants.dateButtonHeigth)
        }
    }
    
// MARK: - Selectors
    
    @objc private func handleDateButton() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd.MM.YYYY"
        if  dateTitleLabel.text == "С какого числа" {
//            let date = datePicker.date
            delegate?.startDate(datePicker.date)
        } else {
//            let date = datePicker.date
            delegate?.finishDate(datePicker.date)
        }
        dismiss(animated: true)
    }
}

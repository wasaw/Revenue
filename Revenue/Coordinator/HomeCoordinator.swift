//
//  HomeCoordinator.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import UIKit

final class HomeCoordinator {
    
// MARK: - Properties
    
    weak var presenterInput: AddTransactionPresenterInput?

    private var navigation: UINavigationController?
    private let detailedCoordinator: DetailedCoordinator
    private let choiceCategoryAssembly: ChoiceCategoryAssembly
    private let showTransactionsAssembly: ShowTransactionsAssembly
    private let calendarAssembly: CalendarAssembly
    private let transactionService: TransactionsServiceProtocol
    private let categoriesService: CategoriesServiceProtocol
    
// MARK: - Lifecycle
    
    init(detailedCoordinator: DetailedCoordinator,
         choiceCategoryAssembly: ChoiceCategoryAssembly,
         showTransactionsAssembly: ShowTransactionsAssembly,
         calendarAssembly: CalendarAssembly,
         transactionService: TransactionsServiceProtocol,
         categoriesService: CategoriesServiceProtocol) {
        self.detailedCoordinator = detailedCoordinator
        self.choiceCategoryAssembly = choiceCategoryAssembly
        self.showTransactionsAssembly = showTransactionsAssembly
        self.calendarAssembly = calendarAssembly
        self.transactionService = transactionService
        self.categoriesService = categoriesService
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let presenter = HomePresenter(output: self,
                                      transactionService: transactionService,
                                      categoriesService: categoriesService)
        let viewController = HomeViewController(output: presenter, outputRevenue: presenter)
        presenter.input = viewController
        let nav = UINavigationController(rootViewController: viewController)
        navigation = nav
        return nav
    }
}

// MARK: - HomePresenterOutput

extension HomeCoordinator: HomePresenterOutput {
    func showDetailed(for transaction: Transaction) {
        let vc = detailedCoordinator.start(transaction: transaction)
        navigation?.pushViewController(vc, animated: false)
    }
    
    func showAddTransaction(isRevenue: Bool) {
        let presenter = AddTransactionPresenter(output: self,
                                                transactionService: transactionService,
                                                isRevenue: isRevenue)
        let vc = AddTransactionViewController(output: presenter)
        presenter.input = vc
        presenterInput = presenter
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showShowTransactions(for category: TransactionCategory) {
        let vc = showTransactionsAssembly.makeShowTransactionsModule(transactionsService: transactionService,
                                                                     output: self,
                                                                     category: category)
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showCalendar() {
        let vc = calendarAssembly.makeShowCalendarModule(output: self)
        vc.modalPresentationStyle = .overCurrentContext
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        let topMostViewController = window.rootViewController
        topMostViewController?.present(vc, animated: true)
    }
    
    func showGoalDetails() {
        let presenter = GoalDetailsPresenter()
        let vc = GoalDetailsViewController(output: presenter)
        presenter.input = vc
        navigation?.pushViewController(vc, animated: true)
    }
}

// MARK: - AddTranactionPresenterOutput

extension HomeCoordinator: AddTransactionPresenterOutput {
    func showChoiceCategory(isRevenue: Bool) {
        let vc = choiceCategoryAssembly.makeChoiceCategoryModule(output: self,
                                                           category: nil,
                                                           categoriesService: categoriesService,
                                                           isRevenue: isRevenue)
        vc.modalPresentationStyle = .overCurrentContext
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        let topMostViewController = window.rootViewController
        topMostViewController?.present(vc, animated: true)
    }
}

// MARK: - ChoiceCaregoryPresenterOutput

extension HomeCoordinator: ChoiceCategoryPresenterOutput {
    func updateSelectedCategory(_ category: TransactionCategory) {
        presenterInput?.updateCategory(category)
    }
    
    func showOtherCategory() {
        let vc = OtherCategory()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        let topMostViewController = window.rootViewController
        topMostViewController?.present(vc, animated: true)
    }
}

// MARK: - OtherCategoryViewControllerDelegate

extension HomeCoordinator: OtherCategoryViewControllerDelegate {
    func addOther() {
    }
    
    func cancel() {
        navigation?.dismiss(animated: true)
    }
}

// MARK: - ShowTransactionsPresenterOutput

extension HomeCoordinator: ShowTransactionsPresenterOutput {
    
}

// MARK: - CalendarPresenterOutput

extension HomeCoordinator: CalendarPresenterOutput {
    func showSelectionDate() {
        let presenter = SelectionDatePresenter()
        let vc = SelectionDateViewController(output: presenter)
        presenter.input = vc
        navigation?.pushViewController(vc, animated: true)
    }
}

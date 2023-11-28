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
    private let transactionService: TransactionsServiceProtocol
    private let categoriesService: CategoriesServiceProtocol
    
// MARK: - Lifecycle
    
    init(detailedCoordinator: DetailedCoordinator,
         choiceCategoryAssembly: ChoiceCategoryAssembly,
         transactionService: TransactionsServiceProtocol,
         categoriesService: CategoriesServiceProtocol) {
        self.detailedCoordinator = detailedCoordinator
        self.choiceCategoryAssembly = choiceCategoryAssembly
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
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showAddTransaction() {
        let presenter = AddTransactionPresenter(output: self, transactionService: transactionService)
        let vc = AddTransactionViewController(output: presenter)
        presenter.input = vc
        presenterInput = presenter
        navigation?.pushViewController(vc, animated: true)
    }
}

// MARK: - AddTranactionPresenterOutput

extension HomeCoordinator: AddTransactionPresenterOutput {
    func showChoiceCategory() {
        let vc = choiceCategoryAssembly.makeDetailedModule(output: self,
                                                           category: nil,
                                                           categoriesService: categoriesService)
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

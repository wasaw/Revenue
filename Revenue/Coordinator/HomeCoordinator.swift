//
//  HomeCoordinator.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import UIKit

final class HomeCoordinator {
    
// MARK: - Properties
    
    private var navigation: UINavigationController?
    private let detailedCoordinator: DetailedCoordinator
    private let transactionService: TransactionsServiceProtocol
    private let categoriesService: CategoriesServiceProtocol
    
// MARK: - Lifecycle
    
    init(detailedCoordinator: DetailedCoordinator,
         transactionService: TransactionsServiceProtocol,
         categoriesService: CategoriesServiceProtocol) {
        self.detailedCoordinator = detailedCoordinator
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
        let presenter = AddTransactionPresenter()
        let vc = AddTransactionViewController(output: presenter)
        presenter.input = vc
        navigation?.pushViewController(vc, animated: true)
    }
}

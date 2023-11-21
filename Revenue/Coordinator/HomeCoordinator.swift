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
    
// MARK: - Lifecycle
    
    init(detailedCoordinator: DetailedCoordinator, transactionService: TransactionsServiceProtocol) {
        self.detailedCoordinator = detailedCoordinator
        self.transactionService = transactionService
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let presenter = HomePresenter(output: self, transactionService: transactionService)
        let viewController = HomeViewController(output: presenter)
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
}

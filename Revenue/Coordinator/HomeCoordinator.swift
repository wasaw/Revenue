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
    private let detailedAssembly: DetailedTransactionAssembly
    
// MARK: - Lifecycle
    
    init(detailedAssembly: DetailedTransactionAssembly) {
        self.detailedAssembly = detailedAssembly
    }
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let presenter = HomePresenter(output: self)
        let viewController = HomeViewController(output: presenter)
        presenter.input = viewController
        let nav = UINavigationController(rootViewController: viewController)
        navigation = nav
        return nav
    }
}

// MARK: - HomePresenterOutput

extension HomeCoordinator: HomePresenterOutput {
    func showDetailed() {
        let vc = detailedAssembly.makeDetailedModule()
        navigation?.pushViewController(vc, animated: true)
    }
}

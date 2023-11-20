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
    private let detailedCoordinator: DetailedCordinator
    
// MARK: - Lifecycle
    
    init(detailedCoordinator: DetailedCordinator) {
        self.detailedCoordinator = detailedCoordinator
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
        let vc = detailedCoordinator.start()
        navigation?.pushViewController(vc, animated: true)
    }
}

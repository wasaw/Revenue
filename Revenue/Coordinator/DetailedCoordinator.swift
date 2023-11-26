//
//  DetailedCoordinator.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import UIKit

final class DetailedCoordinator {
    
// MARK: - Properties
    
    weak var detailedPresenterInput: DetailedTransactionPresenterInput?
    private let detailedAssembly: DetailedTransactionAssembly
    private let choiceCategoryAsembly: ChoiceCategoryAssembly
    private let categoriesService: CategoriesServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private var presenterViewController: UIViewController?
    
// MARK: - Lifecycle
    
    init(detailedAssembly: DetailedTransactionAssembly,
         choiceCategoryAssembly: ChoiceCategoryAssembly,
         categoriesService: CategoriesServiceProtocol,
         transactionsService: TransactionsServiceProtocol) {
        self.detailedAssembly = detailedAssembly
        self.choiceCategoryAsembly = choiceCategoryAssembly
        self.categoriesService = categoriesService
        self.transactionsService = transactionsService
    }
    
// MARK: - Helpers
    
    func start(transaction: Transaction) -> UIViewController {
        let vc = detailedAssembly.makeDetailedModule(output: self,
                                                     transaction: transaction,
                                                     transactionsService: transactionsService,
                                                     categoriesService: categoriesService)
        presenterViewController = vc
        return vc
    }
}

// MARK: - DetailedPresenserOutput

extension DetailedCoordinator: DetailedPresenterOutput {
    func showChoiceCategory(_ category: TransactionCategory) {
        let vc = choiceCategoryAsembly.makeDetailedModule(output: self,
                                                          category: category,
                                                          categoriesService: categoriesService)
        vc.modalPresentationStyle = .overCurrentContext
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        let topMostViewController = window.rootViewController
        topMostViewController?.present(vc, animated: false)
    }
}

// MARK: - ChoiceCategoryPresenterOutput

extension DetailedCoordinator: ChoiceCategoryPresenterOutput {
    func updateSelectedCategory(_ category: TransactionCategory) {
        detailedPresenterInput?.updateTransactionCategory(category)
    }
}

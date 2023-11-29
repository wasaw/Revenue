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
    private let choiceCategoryAssembly: ChoiceCategoryAssembly
    private let categoriesService: CategoriesServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private var presenterViewController: UIViewController?
    private var transaction: Transaction?
    
// MARK: - Lifecycle
    
    init(detailedAssembly: DetailedTransactionAssembly,
         choiceCategoryAssembly: ChoiceCategoryAssembly,
         categoriesService: CategoriesServiceProtocol,
         transactionsService: TransactionsServiceProtocol) {
        self.detailedAssembly = detailedAssembly
        self.choiceCategoryAssembly = choiceCategoryAssembly
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
        let vc = choiceCategoryAssembly.makeChoiceCategoryModule(output: self,
                                                          category: category,
                                                          categoriesService: categoriesService,
                                                          isRevenue: nil)
        vc.modalPresentationStyle = .overCurrentContext
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        let topMostViewController = window.rootViewController
        topMostViewController?.present(vc, animated: false)
    }
    
    func showDeleteAlert(with transaction: Transaction) {
        self.transaction = transaction
        let vc = DeleteViewController()
        vc.delegate = self
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
    
    func showOtherCategory() {
    }
}

// MARK: - DeleteViewControllerDelegate

extension DetailedCoordinator: DeleteViewControllerDelegate {
    func delete() {
        guard let transaction = transaction else { return }
        transactionsService.deleteTransaction(transaction) { [weak self] result in
            switch result {
            case .success:
                self?.presenterViewController?.dismiss(animated: true, completion: {
                    self?.presenterViewController?.navigationController?.popToRootViewController(animated: true)
                })
            case .failure:
                break
            }
        }
    }
    
    func cancel() {
        presenterViewController?.dismiss(animated: true)
    }
}


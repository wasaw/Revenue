//
//  ShowTransactionsPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import Foundation

enum ShowTransactionsCategorySections: Hashable, CaseIterable {
    case section
}

struct ShowTransactionsCategoryItem: Hashable {
    let id = UUID()
    let image: String
    let amount: Double
    let comment: String
    var date: String
}


final class ShowTransactionsPresenter {
    
// MARK: - Properties
    
    weak var input: ShowTransactionsViewControllerInput?
    private let transactionsService: TransactionsServiceProtocol
    private let category: TransactionCategory
    
// MARK: - Lifecycle
    
    init(transactionsService: TransactionsServiceProtocol, category: TransactionCategory) {
        self.transactionsService = transactionsService
        self.category = category
    }
}

// MARK: - ShowTransactionsViewControllerOutput

extension ShowTransactionsPresenter: ShowTransactionsViewControllerOutput {
    func viewIsReady() {
        input?.setTitle(category.title)
        transactionsService.fetchTransctionsForCategory(category) { [weak self] result in
            switch result {
            case .success(let transactions):
                let items: [ShowTransactionsCategoryItem] = transactions.compactMap { transaction in
                    guard let image = self?.category.image else { return nil }
                    return ShowTransactionsCategoryItem(image: image,
                                                        amount: transaction.amount,
                                                        comment: transaction.comment,
                                                        date: "12:50")
                }
                self?.input?.setTransactions(items)
            case .failure:
                break
            }
        }
    }
}

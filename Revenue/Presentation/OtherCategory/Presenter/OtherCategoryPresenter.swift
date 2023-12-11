//
//  OtherCategoryPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

final class OtherCategoryPresenter {
    
// MARK: - Properties
    
    weak var input: OtherCategoryInput?
    private let transactionsService: TransactionsServiceProtocol
    
// MARK: - Lifecycle
    
    init(transactionsService: TransactionsServiceProtocol) {
        self.transactionsService = transactionsService
    }
}

// MARK: - OtherCategoryOutput

extension OtherCategoryPresenter: OtherCategoryOutput {
    func save(_ amount: Double) {
        let category = TransactionCategory(image: "other", title: "Другое", isRevenue: true)
        transactionsService.saveTransaction(Transaction(id: UUID(),
                                                        category: category,
                                                        amount: amount,
                                                        comment: "",
                                                        date: Date())) { [weak self] result in
            switch result {
            case .success:
                self?.input?.backToRoot()
            case .failure:
                break
            }
        }
    }
}

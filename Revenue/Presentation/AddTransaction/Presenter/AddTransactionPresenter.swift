//
//  AddTransactionPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 27.11.2023.
//

import Foundation

final class AddTransactionPresenter {

// MARK: - Properties
    
    weak var input: AddTranactionInput?
    private let output: AddTransactionPresenterOutput
    private let transactionService: TransactionsServiceProtocol
    private let isRevenue: Bool
    private var selectedCategory: TransactionCategory?
    
// MARK: - Lifecycle
    
    init(output: AddTransactionPresenterOutput,
         transactionService: TransactionsServiceProtocol,
         isRevenue: Bool) {
        self.output = output
        self.transactionService = transactionService
        self.isRevenue = isRevenue
    }
}

// MARK: - AddTransactionOutput

extension AddTransactionPresenter: AddTransactionOutput {
    func showChoiceCategory() {
        output.showChoiceCategory(isRevenue: isRevenue)
    }
    
    func saveTransaction(comment: String?, amount: String?) {
        guard let category = selectedCategory,
              let comment = comment,
              let amountString = amount,
              let amount = Double(amountString) else { return }
        let transaction = Transaction(id: UUID(),
                                      category: category,
                                      amount: amount,
                                      comment: comment,
                                      date: Date())
        transactionService.saveTransaction(transaction) { [weak self] result in
            switch result {
            case .success:
                self?.input?.dismissView()
            case .failure:
                break
            }
        }
    }
}

// MARK: - AddTransactionPresenterInput

extension AddTransactionPresenter: AddTransactionPresenterInput {
    func updateCategory(_ category: TransactionCategory) {
        selectedCategory = category
        input?.showCategory(category)
    }
}

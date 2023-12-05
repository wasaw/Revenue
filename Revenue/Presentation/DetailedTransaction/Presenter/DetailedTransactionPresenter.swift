//
//  DetailedTransactionPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import Foundation

final class DetailedTransactionPresenter {
    
// MARK: - Properties
    
    weak var input: DetailedTransactionInput?
    private let output: DetailedPresenterOutput
    private let transactionsService: TransactionsServiceProtocol
    private let categoriesService: CategoriesServiceProtocol
    private let transaction: Transaction
    private var updateCategory: TransactionCategory?
    
// MARK: - Lifecycle
    
    init(output: DetailedPresenterOutput,
         transaction: Transaction,
         transactionsService: TransactionsServiceProtocol,
         categoriesService: CategoriesServiceProtocol) {
        self.output = output
        self.transaction = transaction
        self.transactionsService = transactionsService
        self.categoriesService = categoriesService
        output.detailedPresenterInput = self
    }
    
// MARK: - Helpers
    
    private func deleteLastCharacter(_ text: String?) -> Double? {
        let lastCharacter = text?.last
        if lastCharacter == "c" {
            guard var text = text else { return nil }
            _ = text.popLast()
            return Double(text)
        } else {
            guard let text = text else { return nil }
            return Double(text)
        }
    }
}

// MARK: - DetailedTransactionOutput

extension DetailedTransactionPresenter: DetailedTransactionOutput {
    func viewIsReady() {
        input?.showTransaction(transaction)
    }
    
    func showChoiceCategory() {
        output.showChoiceCategory(transaction.category)
    }
    
    func checkAmountChanges(_ amount: String?) {
        guard let amount = deleteLastCharacter(amount) else { return }
        if transaction.amount != amount {
            input?.turnOnSaveButton()
        }
    }
    
    func saveTransaction(comment: String?, amount: String?) {
        guard let amount = deleteLastCharacter(amount) else { return }
        let comment = comment ?? ""
        if let category = updateCategory {
            try? categoriesService.deleteTransactionFromCategory(transaction: transaction)
            let transaction = Transaction(id: transaction.id,
                                          category: category,
                                          amount: amount,
                                          comment: comment,
                                          date: transaction.date)
            transactionsService.updateTransaction(transaction: transaction) { [weak self] result in
                switch result {
                case .success:
                    self?.input?.dismiss()
                case .failure:
                    break
                }
            }
        } else {
            let transaction = Transaction(id: transaction.id,
                                          category: transaction.category,
                                          amount: amount,
                                          comment: comment,
                                          date: transaction.date)
            transactionsService.updateTransaction(transaction: transaction) { [weak self] result in
                switch result {
                case .success:
                    self?.input?.dismiss()
                case .failure:
                    break
                }
            }
        }
        NotificationCenter.default.post(Notification(name: .updateTransaction))
    }
    
    func showDeleteAlert() {
        output.showDeleteAlert(with: transaction)
    }
}

// MARK: - DetailedTransactionPresenterInput

extension DetailedTransactionPresenter: DetailedTransactionPresenterInput {
    func updateTransactionCategory(_ category: TransactionCategory) {
        updateCategory = category
        let updateTransaction = Transaction(id: transaction.id,
                                            category: category,
                                            amount: transaction.amount,
                                            comment: transaction.comment,
                                            date: transaction.date)
        input?.showTransaction(updateTransaction)
        input?.turnOnSaveButton()
    }
}

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
    private var transaction: Transaction
    
// MARK: - Lifecycle
    
    init(output: DetailedPresenterOutput, transaction: Transaction) {
        self.output = output
        self.transaction = transaction
        output.detailedPresenterInput = self
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
}

// MARK: - DetailedTransactionPresenterInput

extension DetailedTransactionPresenter: DetailedTransactionPresenterInput {
    func updateTransactionCategory(_ category: TransactionCategory) {
        transaction.category = category
        input?.showTransaction(transaction)
    }
}

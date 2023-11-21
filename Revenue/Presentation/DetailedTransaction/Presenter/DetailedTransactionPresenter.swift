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
    private let transaction: Transaction
    
// MARK: - Lifecycle
    
    init(output: DetailedPresenterOutput, transaction: Transaction) {
        self.output = output
        self.transaction = transaction
    }
}

// MARK: - DetailedTransactionOutput

extension DetailedTransactionPresenter: DetailedTransactionOutput {
    func viewIsReady() {
        input?.showTransaction(transaction)
    }
    
    func showChoiceCategory() {
        output.showChoiceCategory()
    }
}

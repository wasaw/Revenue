//
//  TransactionsService.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import Foundation

final class TransactionsService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
    
}

// MARK: - TransactionServiceProtocol

extension TransactionsService: TransactionsServiceProtocol {
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        do {
            let transactionManagedObject = try coreData.fetchTransactions()
            let transactions: [Transaction] = transactionManagedObject.compactMap { transaction in
                guard let category = TransactionCategory(rawValue: Int(transaction.category)),
                      let comment = transaction.comment,
                      let date = transaction.date else {
                    return nil
                }
                return Transaction(category: category,
                                   amount: transaction.amount,
                                   comment: comment,
                                   date: date)
            }
            completion(.success(transactions))
        } catch {
            completion(.failure(error))
        }
    }
}

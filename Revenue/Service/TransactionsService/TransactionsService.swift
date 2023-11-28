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
                guard let id = transaction.id,
                      let comment = transaction.comment,
                      let date = transaction.date,
                      let image = transaction.category?.image,
                      let title = transaction.category?.title,
                      let isRevenue = transaction.category?.isRevenue else { return nil }
                      let category = TransactionCategory(image: image, title: title, isRevenue: isRevenue)
                return Transaction(id: id,
                                   category: category,
                                   amount: transaction.amount,
                                   comment: comment,
                                   date: date)
            }
            completion(.success(transactions))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchTransctionsForCategory(_ category: TransactionCategory, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        do {
            let transactionsManagedObject = try coreData.fetchTransactions()
            let transactions: [Transaction] = transactionsManagedObject.compactMap { transaction in
                guard let id = transaction.id,
                      let comment = transaction.comment,
                      let date = transaction.date,
                      let image = transaction.category?.image,
                      let title = transaction.category?.title,
                      let isRevenue = transaction.category?.isRevenue,
                      (transaction.category?.title == category.title) else { return nil }
                      let category = TransactionCategory(image: image, title: title, isRevenue: isRevenue)
                return Transaction(id: id,
                                   category: category,
                                   amount: transaction.amount,
                                   comment: comment,
                                   date: date)
            }
            completion(.success(transactions))
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateTransaction(transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try coreData.updateTransaction(transaction: transaction)
            completion(.success(Void()))
        } catch {
            print(error)
        }
    }
    
    func deleteTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try coreData.deleteTransaction(transaction)
            completion(.success(Void()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try coreData.saveTransaction(transaction: transaction)
            completion(.success(Void()))
        } catch {
            completion(.failure(error))
        }
    }
}

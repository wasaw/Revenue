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
    private let userDefaults = UserDefaults.standard
    private let formatter = DateFormatter()
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
        
        formatter.dateFormat = "dd.MM.YYYY"
    }
    
}

// MARK: - TransactionServiceProtocol

extension TransactionsService: TransactionsServiceProtocol {
    func fetchTransactions(startDate: Date, finishDate: Date, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        do {
            let transactionManagedObject = try coreData.fetchTransactions()
            let transactions: [Transaction] = transactionManagedObject.compactMap { transaction in
                    guard let id = transaction.id,
                          let comment = transaction.comment,
                          let date = transaction.date,
                          let image = transaction.category?.image,
                          let title = transaction.category?.title,
                          let isRevenue = transaction.category?.isRevenue,
                          date > startDate,
                          date <= finishDate else { return nil }
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
            try coreData.deleteTransactionFromCategory(transaction: transaction)
            completion(.success(Void()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void) {
        coreData.saveTransaction(transaction: transaction, completion: { result in
            switch result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

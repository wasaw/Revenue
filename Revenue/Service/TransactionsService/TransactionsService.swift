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
//        let transaction = [Transaction(category: .salary, amount: 90000, date: Date()),
//                           Transaction(category: .medicine, amount: 27000, date: Date()),
//                           Transaction(category: .transport, amount: 2500, date: Date()),
//                           Transaction(category: .utilities, amount: 20000, date: Date()),
//                           Transaction(category: .loan, amount: 15000, date: Date()),
//                           Transaction(category: .cafe, amount: 30000, date: Date()),
//                           Transaction(category: .entertaiment, amount: 23000, date: Date())]
//        completion(.success(transaction))
    }
}

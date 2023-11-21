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
        let transaction = [Transaction(type: .salary, amount: 90000, date: Date()),
                           Transaction(type: .medicine, amount: 27000, date: Date()),
                           Transaction(type: .transport, amount: 2500, date: Date()),
                           Transaction(type: .utilities, amount: 20000, date: Date()),
                           Transaction(type: .loan, amount: 15000, date: Date()),
                           Transaction(type: .cafe, amount: 30000, date: Date()),
                           Transaction(type: .entertaiment, amount: 23000, date: Date())]
        completion(.success(transaction))
    }
}

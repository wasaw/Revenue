//
//  DefaultValueService.swift
//  Revenue
//
//  Created by Александр Меренков on 21.11.2023.
//

import Foundation

final class DefaultValueService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
}

// MARK: - DefaultValueServiceProtocol

extension DefaultValueService: DefaultValueServiceProtocol {
    func saveTransactions() {
        let transactions = [Transaction(category: .salary, amount: 90000, comment: "", date: Date()),
                           Transaction(category: .medicine, amount: 27000, comment: "", date: Date()),
                           Transaction(category: .transport, amount: 2500, comment: "", date: Date()),
                           Transaction(category: .utilities, amount: 20000, comment: "", date: Date()),
                           Transaction(category: .loan, amount: 15000, comment: "", date: Date()),
                           Transaction(category: .cafe, amount: 30000, comment: "", date: Date()),
                           Transaction(category: .entertaiment, amount: 23000, comment: "", date: Date())]
        transactions.forEach { transaction in
            coreData.save { context in
                let transactionManagedObject = TransactionManagedObject(context: context)
                transactionManagedObject.amount = transaction.amount
                transactionManagedObject.category = Int32(transaction.category.rawValue)
                transactionManagedObject.comment = transaction.comment
                transactionManagedObject.date = transaction.date
            }
        }
    }
}

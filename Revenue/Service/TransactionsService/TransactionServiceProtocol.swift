//
//  TransactionServiceProtocol.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import Foundation

protocol TransactionsServiceProtocol: AnyObject {
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void)
    func updateTransaction(transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTransaction(_ transaction: Transaction)
}

//
//  TransactionServiceProtocol.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import Foundation

protocol TransactionsServiceProtocol: AnyObject {
    func fetchTransactions(startDate: Date, finishDate: Date, completion: @escaping (Result<[Transaction], Error>) -> Void)
    func fetchTransctionsForCategory(_ category: TransactionCategory, completion: @escaping (Result<[Transaction], Error>) -> Void)
    func updateTransaction(transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void)
    func saveTransaction(_ transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void)
}

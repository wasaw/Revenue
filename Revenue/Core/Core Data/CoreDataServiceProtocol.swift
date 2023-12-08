//
//  CoreDataServiceProtocol.swift
//  Revenue
//
//  Created by Александр Меренков on 21.11.2023.
//

import CoreData

protocol CoreDataServiceProtocol: AnyObject {
    func fetchTransactions() throws -> [TransactionManagedObject]
    func updateTransaction(transaction: Transaction) throws -> Void
    func fetchCategories(isRevenue: Bool) throws -> [CategoryManagedObject]
    func save(completion: @escaping (NSManagedObjectContext) throws -> Void)
    func saveTransaction(transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTransaction(_ transaction: Transaction) throws -> Void
    func deleteTransactionFromCategory(transaction: Transaction) throws -> Void
    func fetchGoals() throws -> [GoalManagedObject]
    func fetchContributions(id: UUID) throws -> [GoalManagedObject]
    func deleteGols(for id: UUID)
    func deleteContributions(for id: UUID)
}

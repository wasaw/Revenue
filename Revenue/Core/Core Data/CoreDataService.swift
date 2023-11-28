//
//  CoreDataService.swift
//  Revenue
//
//  Created by Александр Меренков on 21.11.2023.
//

import CoreData

final class CoreDataService {
    
// MARK: - Properties
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores { _, error in
            guard let error = error else { return }
            print(error)
        }
        return persistentContainer
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

// MARK: - CoreDataServiceProtocol

extension CoreDataService: CoreDataServiceProtocol {
    func fetchTransactions() throws -> [TransactionManagedObject] {
        let fetchRequest = TransactionManagedObject.fetchRequest()
        return try viewContext.fetch(fetchRequest)
    }
    
    func updateTransaction(transaction: Transaction) throws {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest = TransactionManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", transaction.id as CVarArg)
        let fetchCategoryRequest = CategoryManagedObject.fetchRequest()
        fetchCategoryRequest.predicate = NSPredicate(format: "title == %@", transaction.category.title)
        do {
            let result = try backgroundContext.fetch(fetchRequest)
            let categoryManagedObject = try backgroundContext.fetch(fetchCategoryRequest).first
            if let item = result.first {
                item.amount = transaction.amount
                item.comment = transaction.comment
            } else {
                let transactionManagedObject = TransactionManagedObject(context: backgroundContext)
                transactionManagedObject.category = categoryManagedObject
                transactionManagedObject.amount = transaction.amount
                transactionManagedObject.id = UUID()
                transactionManagedObject.comment = transaction.comment
                transactionManagedObject.date = transaction.date
                categoryManagedObject?.total += transaction.amount
            }
            if backgroundContext.hasChanges {
                try backgroundContext.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchCategories(isRevenue: Bool) throws -> [CategoryManagedObject] {
        let fetchRequest = CategoryManagedObject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isRevenue == %@", NSNumber(value: isRevenue))
        return try viewContext.fetch(fetchRequest)
    }
    
    func save(completion: @escaping (NSManagedObjectContext) throws -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            do {
                try completion(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveTransaction(transaction: Transaction) throws -> Void {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.performAndWait {
            do {
                let fetchRequest = CategoryManagedObject.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "title == %@", transaction.category.title)
                let categoryManagedObject = try backgroundContext.fetch(fetchRequest).first
                categoryManagedObject?.total += transaction.amount
                let transactionManagedObject = TransactionManagedObject(context: backgroundContext)
                transactionManagedObject.id = transaction.id
                transactionManagedObject.amount = transaction.amount
                transactionManagedObject.comment = transaction.comment
                transactionManagedObject.date = transaction.date
                categoryManagedObject?.addToTransactions(transactionManagedObject)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteTransaction(_ transaction: Transaction) throws {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.performAndWait {
            do {
                let fetchRequest = TransactionManagedObject.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", transaction.id as CVarArg)
                guard let transactionManagedObject = try backgroundContext.fetch(fetchRequest).first else { return }
                backgroundContext.delete(transactionManagedObject)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteTransactionFromCategory(transaction: Transaction) throws {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.performAndWait {
            do {
                let fetchRequest = CategoryManagedObject.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "title == %@", transaction.category.title)
                let categoryManagedObject = try backgroundContext.fetch(fetchRequest).first
                guard let transactionCollection = categoryManagedObject?.transactions?.array as? [TransactionManagedObject] else { return }
                for item in transactionCollection {
                    if item.id == transaction.id {
                        categoryManagedObject?.total -= item.amount
                        backgroundContext.delete(item)
                    }
                }
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

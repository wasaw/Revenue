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
}

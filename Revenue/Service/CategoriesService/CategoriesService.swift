//
//  CategoriesService.swift
//  Revenue
//
//  Created by Александр Меренков on 23.11.2023.
//

import Foundation

final class CategoriesService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
}

// MARK: - CategoriesServiceProtocol

extension CategoriesService: CategoriesServiceProtocol {
    func fetchCategories(isRevenue: Bool, completion: @escaping (Result<(categories: [TransactionCategory], total: Double), Error>) -> Void) {
        do {
            var total: Double = 0
            let categoryManagedObject = try coreData.fetchCategories(isRevenue: isRevenue)
            let transactionCategory: [TransactionCategory] = categoryManagedObject.compactMap { category in
                guard let image = category.image,
                      let title = category.title else {
                    return nil
                }
                total += category.total
                return TransactionCategory(image: image,
                                                    title: title,
                                                    isRevenue: category.isRevenue,
                                                    total: category.total)
            }
            completion(.success((categories: transactionCategory, total: total)))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteTransactionFromCategory(transaction: Transaction) throws {
        do {
            try coreData.deleteTransactionFromCategory(transaction: transaction)
        } catch {
            print(error.localizedDescription)
        }
    }
}

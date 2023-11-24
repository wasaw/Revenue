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
    func fetchCategories(isRevenue: Bool, completion: @escaping (Result<[TransactionCategory], Error>) -> Void) {
        do {
            let categoryManagedObject = try coreData.fetchCategories(isRevenue: isRevenue)
            let transactionCategory: [TransactionCategory] = categoryManagedObject.compactMap { category in
                guard let image = category.image,
                      let title = category.title else {
                    return nil
                }
                return TransactionCategory(image: image,
                                                    title: title,
                                                    isRevenue: category.isRevenue,
                                                    total: category.total)
            }
            completion(.success(transactionCategory))
        } catch {
            completion(.failure(error))
        }
    }
}

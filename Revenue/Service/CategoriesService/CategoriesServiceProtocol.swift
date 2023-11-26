//
//  CategoriesServiceProtocol.swift
//  Revenue
//
//  Created by Александр Меренков on 23.11.2023.
//

import Foundation

protocol CategoriesServiceProtocol: AnyObject {
    func fetchCategories(isRevenue: Bool, completion: @escaping (Result<(categories: [TransactionCategory], total: Double), Error>) -> Void)
    func deleteTransactionFromCategory(transaction: Transaction) throws -> Void
}

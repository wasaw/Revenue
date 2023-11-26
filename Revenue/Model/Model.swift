//
//  Model.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import Foundation

struct Transaction {
    let id: UUID
    var category: TransactionCategory
    let amount: Double
    let comment: String
    let date: Date
}

struct TransactionCategory {
    let image: String
    let title: String
    let isRevenue: Bool
    var total: Double = 0
}

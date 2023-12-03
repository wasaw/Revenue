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

struct Goal {
    let id: UUID
    let image: String
    let title: String
    let introduced: Double
    let total: Double
    let date: Date
    let isFinished: Bool
}

struct Contribution {
    let amount: Double
    let date: Date
    let goal: UUID
}

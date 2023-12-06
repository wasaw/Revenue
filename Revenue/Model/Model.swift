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
    
    var amountForOutput: String {
        guard let string = numberFormatter.string(from: amount as NSNumber) else { return "" }
        return  string + " c"
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        return formatter
    }()
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
    
    var amountForOutput: String {
        guard let string = numberFormatter.string(from: total as NSNumber) else { return "" }
        return  string + " c"
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        return formatter
    }()
}

struct Contribution {
    let id: UUID
    let amount: Double
    let date: Date
    let goal: UUID
}

enum DefaultsValues {
    static let startDate = "startDate"
    static let finishDate = "finishDate"
}

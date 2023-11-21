//
//  Model.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import Foundation

struct Transaction {
    let category: TransactionCategory
    let amount: Double
    let comment: String
    let date: Date
}

enum TransactionCategory: Int {
    case salary
    case medicine
    case transport
    case utilities
    case loan
    case cafe
    case entertaiment
    
    func getInformation() -> TransactionCategoryStructure {
        switch self {
        case .salary:
            return TransactionCategoryStructure(image: "salary", title: "Заработная плата", isRevenue: true)
        case .medicine:
            return TransactionCategoryStructure(image: "medicine", title: "Медицина", isRevenue: false)
        case .transport:
            return TransactionCategoryStructure(image: "transport", title: "Транспорт", isRevenue: false)
        case .utilities:
            return TransactionCategoryStructure(image: "utilities", title: "Коммунальные услуги", isRevenue: false)
        case .loan:
            return TransactionCategoryStructure(image: "loan", title: "Деньги взаймы", isRevenue: false)
        case .cafe:
            return TransactionCategoryStructure(image: "cafe", title: "Кафе и рестораны", isRevenue: false)
        case .entertaiment:
            return TransactionCategoryStructure(image: "entertainment", title: "Резвлечения", isRevenue: false)
        }
    }
}

struct TransactionCategoryStructure {
    let image: String
    let title: String
    let isRevenue: Bool
}

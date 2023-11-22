//
//  Model.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import Foundation

struct Transaction {
    var category: TransactionCategory
    let amount: Double
    let comment: String
    let date: Date
}

enum TransactionCategory: Int, CaseIterable {
    case salary
    case business
    case credit
    case deposite
    case grant
    case capital
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
        case .business:
            return TransactionCategoryStructure(image: "business", title: "Доходы от бизнеса", isRevenue: true)
        case .credit:
            return TransactionCategoryStructure(image: "credit", title: "Кредит/Долг", isRevenue: true)
        case .deposite:
            return TransactionCategoryStructure(image: "deposit", title: "Депозит", isRevenue: true)
        case .grant:
            return TransactionCategoryStructure(image: "grant", title: "Стипендия", isRevenue: true)
        case .capital:
            return TransactionCategoryStructure(image: "capital", title: "Сбережения", isRevenue: true)
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

//
//  Model.swift
//  Revenue
//
//  Created by Александр Меренков on 20.11.2023.
//

import Foundation

struct Transaction {
    let type: TransactionType
    let amount: Double
    let date: Date
}

extension Transaction {
    enum TransactionType {
        case salary
        case medicine
        case transport
        case utilities
        case loan
        case cafe
        case entertaiment
        
        func getInformation() -> TransactionStructure {
            switch self {
            case .salary:
                return TransactionStructure(image: "salary", title: "Заработная плата", isRevenue: true)
            case .medicine:
                return TransactionStructure(image: "medicine", title: "Медицина", isRevenue: false)
            case .transport:
                return TransactionStructure(image: "transport", title: "Транспорт", isRevenue: false)
            case .utilities:
                return TransactionStructure(image: "utilities", title: "Коммунальные услуги", isRevenue: false)
            case .loan:
                return TransactionStructure(image: "loan", title: "Деньги взаймы", isRevenue: false)
            case .cafe:
                return TransactionStructure(image: "cafe", title: "Кафе и рестораны", isRevenue: false)
            case .entertaiment:
                return TransactionStructure(image: "entertainment", title: "Резвлечения", isRevenue: false)
            }
        }
    }

    struct TransactionStructure {
        let image: String
        let title: String
        let isRevenue: Bool
    }
}

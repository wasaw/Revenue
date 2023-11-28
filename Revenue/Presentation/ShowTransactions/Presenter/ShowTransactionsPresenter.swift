//
//  ShowTransactionsPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import Foundation

enum ShowTransactionsCategorySections: Hashable, CaseIterable {
    case section
}

struct ShowTransactionsCategoryItem: Hashable {
    let id = UUID()
    let image: String
    let amount: Double
    let comment: String
    var date: String
}


final class ShowTransactionsPresenter {
    
// MARK: - Properties
    
    weak var input: ShowTransactionsViewControllerInput?
    
}

// MARK: - ShowTransactionsViewControllerOutput

extension ShowTransactionsPresenter: ShowTransactionsViewControllerOutput {
    
}

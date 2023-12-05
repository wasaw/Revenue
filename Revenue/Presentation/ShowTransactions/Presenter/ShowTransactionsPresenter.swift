//
//  ShowTransactionsPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import Foundation

struct ShowTransactions {
    let sections: [String]
    let items: [ShowTransactionsCategoryItem]
}

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

var sectionsShowArray: [String] = []

final class ShowTransactionsPresenter {
    
// MARK: - Properties
    
    weak var input: ShowTransactionsViewControllerInput?
    private let output: ShowTransactionsPresenterOutput
    private let transactionsService: TransactionsServiceProtocol
    private let category: TransactionCategory
    private var transactions: [Transaction] = []
    private let timeFormatter = DateFormatter()
    private let dateFormatter = DateFormatter()
    
// MARK: - Lifecycle
    
    init(transactionsService: TransactionsServiceProtocol,
         output: ShowTransactionsPresenterOutput,
         category: TransactionCategory) {
        self.transactionsService = transactionsService
        self.output = output
        self.category = category
        
        timeFormatter.dateFormat = "HH:mm"
        dateFormatter.dateFormat = "dd.MM.YYYY"
    }
}

// MARK: - ShowTransactionsViewControllerOutput

extension ShowTransactionsPresenter: ShowTransactionsViewControllerOutput {
    func viewIsReady() {
        input?.setTitle(category.title)
        transactionsService.fetchTransctionsForCategory(category) { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                var dateArray: [String] = []
                var showTransactions: [ShowTransactions] = []
                transactions.forEach { [weak self] transaction in
                    guard let day = self?.dateFormatter.string(from: transaction.date) else {
                        return
                    }
                    if dateArray.isEmpty {
                        dateArray.append(day)
                    } else {
                        let last = dateArray.last
                        if last != day {
                            dateArray.append(day)
                        }
                    }
                }
                sectionsShowArray = dateArray
                dateArray.forEach { dateItem in
                    var items: [ShowTransactionsCategoryItem] = []
                    transactions.forEach { transaction in
                        let day = self?.dateFormatter.string(from: transaction.date)
                        if dateItem == day {
                            guard let image = self?.category.image,
                                  let date = self?.timeFormatter.string(from: transaction.date) else { return }
                            let element = ShowTransactionsCategoryItem(image: image,
                                                                       amount: transaction.amount,
                                                                       comment: transaction.comment,
                                                                       date: date)
                            items.append(element)
                        }
                    }
                    let showTransactionsElement = ShowTransactions(sections: [dateItem], items: items)
                    showTransactions.append(showTransactionsElement)
                }
                self?.input?.setTransactions(for: showTransactions)
            case .failure:
                break
            }
        }
    }
    
    func showDetailed(at index: Int) {
        output.showDetailed(for: transactions[index])
    }
}

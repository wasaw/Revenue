//
//  HomePresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import Foundation

struct HomeTransactions {
    let sections: HomeRemainsSections
    let item: [HomeRemainsItem]
}

enum HomeRemainsSections: String, Hashable, CaseIterable {
    case section1 = "First"
//    case section2 = "Second"
}

struct HomeRemainsItem: Hashable {
    let id = UUID()
    let image: String
    let title: String
    let amount: Double
    let time: String
}

enum HomeRevenueSections: Hashable, CaseIterable {
    case section
}

struct HomeRevenueItem: Hashable {
    let id = UUID()
    let image: String
    let title: String
    let amount: Double
    let percent: Double
}

enum Segment: Int {
    case remains
    case revenue
    case expenses
    case goals
}

struct Expense {
    let category: Category
    var amount: Double
}

final class HomePresenter {
    
// MARK: - Properties
    
    weak var input: HomeInputProtocol?
    private let output: HomePresenterOutput
    private let transactionService: TransactionsServiceProtocol
    private let categoriesService: CategoriesServiceProtocol
    
    private var selectedTransactions: [Transaction] = []
    private var revenueCategories: [TransactionCategory] = []

// MARK: - Lifecycle
    
    init(output: HomePresenterOutput,
         transactionService: TransactionsServiceProtocol,
         categoriesService: CategoriesServiceProtocol) {
        self.output = output
        self.transactionService = transactionService
        self.categoriesService = categoriesService
    }
}

// MARK: HomeOutputProtocol

extension HomePresenter: HomeOutput {
    func viewIsReady() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        transactionService.fetchTransactions { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.selectedTransactions = transactions
                let items = transactions.compactMap { transaction in
                    let date = dateFormatter.string(from: transaction.date)
                    return HomeRemainsItem(image: transaction.category.image,
                                           title: transaction.category.title,
                                           amount: transaction.amount,
                                           time: date)
                }
                let homeTransactions = HomeTransactions(sections: .section1, item: items)
                self?.input?.setTransactions([homeTransactions])
            case .failure:
                break
            }
        }
    }
    
    func showDetails(at index: Int, in section: Int) {
        let transaction = selectedTransactions[index]
        output.showDetailed(for: transaction)
    }
    
    func fetchData(for segment: Segment) {
        switch segment {
        case .remains:
            break
        case .revenue:
            categoriesService.fetchCategories(isRevenue: true) { [weak self] result in
                switch result {
                case .success(let tuple):
                    let items = tuple.categories.compactMap { [weak self] category in
                        self?.revenueCategories.append(category)
                        return HomeRevenueItem(image: category.image,
                                               title: category.title,
                                               amount: category.total,
                                               percent: ((category.total / tuple.total) * 100))
                    }
                    self?.input?.setRevenue(items)
                case .failure:
                    break
                }
            }
        case .expenses:
            break
        case .goals:
            break
        }
    }
}

// MARK: - HomeRevenueOutput

extension HomePresenter: HomeRevenueOutput {
    func showAddTransaction() {
        output.showAddTransaction()
    }
    
    func showDetails(at index: Int) {
        output.showShowTransactions(for: revenueCategories[index])
    }
}

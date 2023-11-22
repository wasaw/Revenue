//
//  HomePresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import Foundation

struct HomeTransactions {
    let sections: HomeSections
    let item: [HomeItem]
}

enum HomeSections: String, Hashable, CaseIterable {
    case section1 = "First"
//    case section2 = "Second"
}

struct HomeItem: Hashable {
    let id = UUID()
    let image: String
    let title: String
    let amount: Double
    let time: String
}

final class HomePresenter {
    
// MARK: - Properties
    
    weak var input: HomeInputProtocol?
    private let output: HomePresenterOutput
    private let transactionService: TransactionsServiceProtocol
    
    private var selectedTransactions: [Transaction] = []

// MARK: - Lifecycle
    
    init(output: HomePresenterOutput, transactionService: TransactionsServiceProtocol) {
        self.output = output
        self.transactionService = transactionService
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
                    let type = transaction.category.getInformation()
                    let date = dateFormatter.string(from: transaction.date)
                    return HomeItem(image: type.image, title: type.title, amount: transaction.amount, time: date)
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
}

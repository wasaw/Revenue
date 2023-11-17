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
    case section2 = "Second"
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
}

// MARK: HomeOutputProtocol

extension HomePresenter: HomeOutput {
    func viewIsReady() {
        let homeItems1 = [HomeItem(image: "salary", title: "Заработная плата", amount: 90000, time: "12:34"),
                          HomeItem(image: "salary", title: "Медицина", amount: 270000, time: "12:34")]
        let transaction1 = HomeTransactions(sections: .section1, item: homeItems1)
        let homeItems2 = [HomeItem(image: "salary", title: "Заработная плата", amount: 90000, time: "12:34"),
                          HomeItem(image: "salary", title: "Медицина", amount: 270000, time: "12:34")]
        let transaction2 = HomeTransactions(sections: .section2, item: homeItems2)
        let transactions = [transaction1, transaction2]
        input?.setTransactions(transactions)
    }
}

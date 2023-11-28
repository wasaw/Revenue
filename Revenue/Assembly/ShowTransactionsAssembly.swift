//
//  ShowTransactionsAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import UIKit

final class ShowTransactionsAssembly {
    func makeShowTransactionsModule(transactionsService: TransactionsServiceProtocol, category: TransactionCategory) -> UIViewController {
        let presenter = ShowTransactionsPresenter(transactionsService: transactionsService, category: category)
        let vc = ShowTransactionViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}

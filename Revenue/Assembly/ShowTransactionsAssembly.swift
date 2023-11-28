//
//  ShowTransactionsAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import UIKit

final class ShowTransactionsAssembly {
    func makeShowTransactionsModule() -> UIViewController {
        let presenter = ShowTransactionsPresenter()
        let vc = ShowTransactionViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}

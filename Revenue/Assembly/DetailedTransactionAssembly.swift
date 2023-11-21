//
//  DetailedTransactionAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import UIKit

final class DetailedTransactionAssembly {
    func makeDetailedModule(output: DetailedPresenterOutput, transaction: Transaction) -> UIViewController {
        let presenter = DetailedTransactionPresenter(output: output, transaction: transaction)
        let viewController = DetailedTransactionViewController(output: presenter)
        presenter.input = viewController
        return viewController
    }
}

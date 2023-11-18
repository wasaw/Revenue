//
//  DetailedTransactionAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import UIKit

final class DetailedTransactionAssembly {
    func makeDetailedModule() -> UIViewController {
        let presenter = DetailedTransactionPresenter()
        let viewController = DetailedTransactionViewController(output: presenter)
        presenter.input = viewController
        return viewController
    }
}

//
//  ChoiceCategoryAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import UIKit

final class ChoiceCategoryAssembly {
    func makeDetailedModule(output: ChoiceCategoryPresenterOutput, category: TransactionCategory) -> UIViewController {
        let presenter = ChoiceCategoryPresenter(output: output, selectedCategory: category)
        let vc = ChoiceCategoryViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}

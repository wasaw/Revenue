//
//  ChoiceCategoryAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import UIKit

final class ChoiceCategoryAssembly {
    func makeChoiceCategoryModule(output: ChoiceCategoryPresenterOutput,
                            category: TransactionCategory?,
                            categoriesService: CategoriesServiceProtocol,
                                  isRevenue: Bool?) -> UIViewController {
        let presenter = ChoiceCategoryPresenter(output: output,
                                                selectedCategory: category,
                                                categoriesService: categoriesService,
                                                isRevenue: isRevenue)
        let vc = ChoiceCategoryViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}

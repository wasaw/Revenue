//
//  ChoiceCategoryAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import UIKit

final class ChoiceCategoryAssembly {
    func makeDetailedModule(output: ChoiceCategoryPresenterOutput,
                            category: TransactionCategory,
                            categoriesService: CategoriesServiceProtocol) -> UIViewController {
        let presenter = ChoiceCategoryPresenter(output: output,
                                                selectedCategory: category,
                                                categoriesService: categoriesService)
        let vc = ChoiceCategoryViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}

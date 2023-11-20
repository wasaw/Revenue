//
//  ChoiceCategoryPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import Foundation

enum TableCategorySections: Hashable, CaseIterable {
    case section
}

struct TableCategoryItem: Hashable {
    let id = UUID()
    let image: String
    let title: String
    var isSelected: Bool
}

final class ChoiceCategoryPresenter {
    
// MARK: - Properties
    
    weak var input: ChoiceInput?
}

// MARK: - ChoiceOutput

extension ChoiceCategoryPresenter: ChoiceOutput {
    func viewIsReady() {
        let items = [TableCategoryItem(image: "salary", title: "Другое", isSelected: false),
                     TableCategoryItem(image: "salary", title: "Заработная плата", isSelected: true),
                     TableCategoryItem(image: "salary", title: "Другое", isSelected: false),
                     TableCategoryItem(image: "salary", title: "Заработная плата", isSelected: true),
                     TableCategoryItem(image: "salary", title: "Другое", isSelected: false),
                     TableCategoryItem(image: "salary", title: "Заработная плата", isSelected: true),
                     TableCategoryItem(image: "salary", title: "Другое", isSelected: false),
                     TableCategoryItem(image: "salary", title: "Заработная плата", isSelected: true),
                     TableCategoryItem(image: "salary", title: "Другое", isSelected: false),
                     TableCategoryItem(image: "salary", title: "Заработная плата", isSelected: true),
                     TableCategoryItem(image: "salary", title: "Другое", isSelected: false),
                     TableCategoryItem(image: "salary", title: "Заработная плата", isSelected: true)]
        input?.setCategories(items)
    }
}

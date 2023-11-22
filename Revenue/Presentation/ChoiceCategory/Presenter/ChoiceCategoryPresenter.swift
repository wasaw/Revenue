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
    let isRevenue: Bool
    var isSelected: Bool
}

final class ChoiceCategoryPresenter {
    
// MARK: - Properties
    
    weak var input: ChoiceInput?
    private let output: ChoiceCategoryPresenterOutput
    private var selectedCategory: TransactionCategory
    private var revenue: [TableCategoryItem] = []
    private var expense: [TableCategoryItem] = []
    
// MARK: - Lifecycle
    
    init(output: ChoiceCategoryPresenterOutput, selectedCategory: TransactionCategory) {
        self.output = output
        self.selectedCategory = selectedCategory
    }
}

// MARK: - ChoiceOutput

extension ChoiceCategoryPresenter: ChoiceOutput {
    func fetchRevenue() {
        input?.setCategories(revenue)
    }
    
    func fetchExpense() {
        input?.setCategories(expense)
    }
    
    func viewIsReady() {
        let items = TransactionCategory.allCases.compactMap { category in
            let info = category.getInformation()
            let isSelected = (category == selectedCategory) ? true : false
            return TableCategoryItem(image: info.image,
                                     title: info.title,
                                     isRevenue: info.isRevenue,
                                     isSelected: isSelected)
        }
        items.forEach { item in
            item.isRevenue ? revenue.append(item) : expense.append(item)
        }
        input?.setCategories(revenue)
    }
    
    func updateSelectedCell(at index: Int, in segment: Int) {
        if segment == 0 {
            let items = TransactionCategory.allCases.compactMap { category in
                let info = category.getInformation()
                let isSelected = (info.title == revenue[index].title) ? true : false
                if (info.title == revenue[index].title) {
                    selectedCategory = category
                }
                return TableCategoryItem(image: info.image,
                                         title: info.title,
                                         isRevenue: info.isRevenue,
                                         isSelected: isSelected)
            }
            revenue = []
            expense = []
            items.forEach { item in
                item.isRevenue ? revenue.append(item) : expense.append(item)
            }
            input?.setCategories(revenue)
        } else {
            let items = TransactionCategory.allCases.compactMap { category in
            let info = category.getInformation()
            let isSelected = (info.title == expense[index].title) ? true : false
            if (info.title == expense[index].title) {
                selectedCategory = category
            }
            return TableCategoryItem(image: info.image,
                                     title: info.title,
                                     isRevenue: info.isRevenue,
                                     isSelected: isSelected)
            }
            revenue = []
            expense = []
            items.forEach { item in
                item.isRevenue ? revenue.append(item) : expense.append(item)
            }
            input?.setCategories(expense)
        }
    }
    
    func updateSelectedCategory() {
        output.updateSelectedCategory(selectedCategory)
    }
}

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
    private let categoriesService: CategoriesServiceProtocol
    private var selectedCategory: TransactionCategory
    private var revenue: [TableCategoryItem] = []
    private var expense: [TableCategoryItem] = []
    
// MARK: - Lifecycle
    
    init(output: ChoiceCategoryPresenterOutput,
         selectedCategory: TransactionCategory,
         categoriesService: CategoriesServiceProtocol) {
        self.output = output
        self.selectedCategory = selectedCategory
        self.categoriesService = categoriesService
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
        categoriesService.fetchCategories(isRevenue: true) { [weak self] result in
            switch result {
            case .success(let tuple):
                let items: [TableCategoryItem] = tuple.categories.compactMap { category in
                    let isSelected = (category.title == self?.selectedCategory.title) ? true : false
                    return TableCategoryItem(image: category.image, title: category.title, isRevenue: category.isRevenue, isSelected: isSelected)
                }
                self?.input?.setCategories(items)
                self?.revenue = items
            case .failure:
                break
            }
        }
        categoriesService.fetchCategories(isRevenue: false) { [weak self] result in
            switch result {
            case .success(let tuple):
                let items: [TableCategoryItem] = tuple.categories.compactMap { category in
                    let isSelected = (category.title == self?.selectedCategory.title) ? true : false
                    return TableCategoryItem(image: category.image, title: category.title, isRevenue: category.isRevenue, isSelected: isSelected)
                }
                self?.expense = items
            case .failure:
                break
            }
        }
    }
    
    func updateSelectedCell(at index: Int, in segment: Int) {
        if segment == 0 {
            revenue.enumerated().forEach { iElement, _ in
                revenue[iElement].isSelected = (iElement == index) ? true : false
            }
            expense.enumerated().forEach { i, _ in
                expense[i].isSelected = false
            }
            selectedCategory = TransactionCategory(image: revenue[index].image,
                                                   title: revenue[index].title,
                                                   isRevenue: revenue[index].isRevenue)
            input?.setCategories(revenue)
        } else {
            expense.enumerated().forEach { iElement, _ in
                expense[iElement].isSelected = (iElement == index) ? true : false
            }
            revenue.enumerated().forEach { i, _ in
                revenue[i].isSelected = false
            }
            selectedCategory = TransactionCategory(image: expense[index].image,
                                                   title: expense[index].title,
                                                   isRevenue: expense[index].isRevenue)
            input?.setCategories(expense)
        }
    }
    
    func updateSelectedCategory() {
        output.updateSelectedCategory(selectedCategory)
    }
}

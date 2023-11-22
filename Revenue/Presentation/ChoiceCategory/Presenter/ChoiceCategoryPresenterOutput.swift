//
//  ChoiceCategoryPresenterOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 21.11.2023.
//

import Foundation

protocol ChoiceCategoryPresenterOutput: AnyObject {
    func updateSelectedCategory(_ category: TransactionCategory)
}

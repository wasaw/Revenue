//
//  ChoiceOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import Foundation

protocol ChoiceOutput: AnyObject {
    func viewIsReady()
    func fetchRevenue()
    func fetchExpense()
    func updateSelectedCell(at index: Int, in segment: Int)
    func updateSelectedCategory()
}

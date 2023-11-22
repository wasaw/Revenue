//
//  DetailedPresenterOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import Foundation

protocol DetailedPresenterOutput: AnyObject {
    var detailedPresenterInput: DetailedTransactionPresenterInput? { get set }

    func showChoiceCategory(_ category: TransactionCategory)
}

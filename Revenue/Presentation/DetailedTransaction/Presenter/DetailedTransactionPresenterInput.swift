//
//  DetailedTransactionPresenterInput.swift
//  Revenue
//
//  Created by Александр Меренков on 21.11.2023.
//

import Foundation

protocol DetailedTransactionPresenterInput: AnyObject {
    func updateTransactionCategory(_ category: TransactionCategory)
}

//
//  AddTransactionPresenterInput.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import Foundation

protocol AddTransactionPresenterInput: AnyObject {
    func updateCategory(_ category: TransactionCategory)
}

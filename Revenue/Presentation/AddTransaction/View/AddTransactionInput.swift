//
//  AddTransactionInput.swift
//  Revenue
//
//  Created by Александр Меренков on 27.11.2023.
//

import Foundation

protocol AddTranactionInput: AnyObject {
    func showCategory(_ category: TransactionCategory)
    func dismissView()
}

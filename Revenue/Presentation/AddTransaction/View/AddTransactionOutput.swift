//
//  AddTransactionOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 27.11.2023.
//

import Foundation

protocol AddTransactionOutput: AnyObject {
    func showChoiceCategory()
    func saveTransaction(comment: String?, amount: String?)
}

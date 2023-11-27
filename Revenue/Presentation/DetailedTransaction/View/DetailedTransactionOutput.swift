//
//  DetailedTransactionOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import Foundation

protocol DetailedTransactionOutput: AnyObject {
    func viewIsReady()
    func showChoiceCategory()
    func checkAmountChanges(_ amount: String?)
    func saveTransaction(comment: String?, amount: String?)
    func showDeleteAlert()
}

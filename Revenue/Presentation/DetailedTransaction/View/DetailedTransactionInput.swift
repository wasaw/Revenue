//
//  DetailedTransactionInput.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import Foundation

protocol DetailedTransactionInput: AnyObject {
    func showTransaction(_ transaction: Transaction)
    func turnOnSaveButton()
    func dismiss()
}

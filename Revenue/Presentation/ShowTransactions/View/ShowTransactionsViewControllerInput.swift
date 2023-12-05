//
//  ShowTransactionsViewControllerInput.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import Foundation

protocol ShowTransactionsViewControllerInput: AnyObject {
    func setTitle(_ title: String)
    func setTransactions(for items: [ShowTransactions])
}

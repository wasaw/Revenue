//
//  ShowTransactionsPresenterOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import Foundation

protocol ShowTransactionsPresenterOutput: AnyObject {
    func showDetailed(for transaction: Transaction)
}

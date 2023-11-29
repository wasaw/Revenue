//
//  HomeTransactionsOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 27.11.2023.
//

import Foundation

protocol HomeTransactionsOutput: AnyObject {
    func showAddTransaction()
    func showDetails(at index: Int)
}

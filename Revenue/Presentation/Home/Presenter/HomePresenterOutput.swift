//
//  HomePresenterOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import Foundation

protocol HomePresenterOutput: AnyObject {
    func showDetailed(for transaction: Transaction)
    func showAddTransaction()
}

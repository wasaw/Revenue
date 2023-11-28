//
//  ShowTransactionsViewControllerOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 28.11.2023.
//

import Foundation

protocol ShowTransactionsViewControllerOutput: AnyObject {
    func viewIsReady()
    func showDetailed(at index: Int)
}

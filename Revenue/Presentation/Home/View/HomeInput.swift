//
//  HomeInput.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import Foundation

protocol HomeInputProtocol: AnyObject {
    func setTransactions(_ items: [HomeTransactions])
    func setRevenue(_ items: [HomeRevenueItem])
}

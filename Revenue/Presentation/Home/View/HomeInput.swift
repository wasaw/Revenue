//
//  HomeInput.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import Foundation

protocol HomeInputProtocol: AnyObject {
    func setTransactions(for items: [HomeTransactions], total: Double)
    func setRevenue(_ items: [HomeRevenueItem])
    func setCalendarDate(from start: String, to finish: String)
    func setGoals(_ items: [HomeGoalsItem], total: Double)
    func showPopUp(_ title: PopUpTitle)
}

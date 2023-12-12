//
//  GoalDetailsInput.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import Foundation

protocol GoalDetailsInput: AnyObject {
    func setData(_ items: [GoalDetailsItem])
    func setGoalData(_ item: Goal)
    func showPopUp(_ title: PopUpTitle)
}

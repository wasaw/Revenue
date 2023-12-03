//
//  GoalDetailsInput.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import Foundation

protocol GoalDetailsInput: AnyObject {
    func setDate(_ items: [GoalDetilsItem])
    func setGoalData(_ item: Goal)
}

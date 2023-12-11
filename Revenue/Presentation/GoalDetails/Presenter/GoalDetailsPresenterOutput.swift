//
//  GoalDetailsPresenterOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

protocol GoalDetailsPresenterOutput: AnyObject {
    func showGoalEditView(for id: UUID)
    func showAddDetailView(for id: UUID)
    func showAllDetailsView(goalItems: [GoalDetailsItem])
}

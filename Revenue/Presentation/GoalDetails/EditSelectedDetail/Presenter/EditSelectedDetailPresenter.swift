//
//  EditSelectedDetailPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

final class EditSelectedDetailPresenter {
    
// MARK: - Properties
    
    weak var input: EditSelectedDetailInput?
    private let contributionsService: ContributionsServiceProtocol
    private let goalItem: GoalDetailsItem
    
    
// MARK: - Lifecycle
    
    init(contributionsService: ContributionsServiceProtocol, goalItem: GoalDetailsItem) {
        self.contributionsService = contributionsService
        self.goalItem = goalItem
    }
}
// MARK: - EditSelectedDetailOutput

extension EditSelectedDetailPresenter: EditSeelctedDetailOutput {
    func viewIsReady() {
        input?.setData(goalItem)
    }
    
    func save(_ amount: Double) {
        contributionsService.saveContribution(Contribution(id: UUID(), amount: amount, date: Date(), goal: goalItem.goalId))
    }
    
    func delete() {
        contributionsService.delete(for: goalItem.detailId)
        NotificationCenter.default.post(Notification(name: .delete))
    }
}

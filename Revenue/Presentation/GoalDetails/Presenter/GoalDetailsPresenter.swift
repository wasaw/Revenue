//
//  GoalDetailsPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import Foundation

enum GoalDetailsSections: Hashable, CaseIterable {
    case section
}

struct GoalDetilsItem: Hashable {
    let id = UUID()
    let date: Date
    let amount: Double
    let detailId: UUID
    let goalId: UUID
    
    var amountForOutput: String {
        guard let string = numberFormatter.string(from: amount as NSNumber) else { return "" }
        return  string + " c"
    }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        return formatter
    }()
}

final class GoalDetailsPresenter {
    
// MARK: - Properties
    
    weak var input: GoalDetailsInput?
    private let goalsService: GoalsServiceProtocol
    private let contributinsService: ContributionsServiceProtocol
    private let id: UUID
    
// MARK: - Lifecycle
    
    init(goalsService: GoalsServiceProtocol, contributinsService: ContributionsServiceProtocol, id: UUID) {
        self.goalsService = goalsService
        self.contributinsService = contributinsService
        self.id = id
    }
}

// MARK: - GoalDetaislOutput

extension GoalDetailsPresenter: GoalDetailsOutput {
    func viewIsReady() {
        goalsService.fetchGoals { [weak self] result in
            switch result {
            case .success(let goals):
                goals.forEach { goal in
                    if goal.id == self?.id {
                        self?.input?.setGoalData(goal)
                    }
                }
            case .failure:
                break
            }
        }
        
        contributinsService.fetchContributions(for: id) { [weak self] result in
            switch result {
            case .success(let contributions):
                let items: [GoalDetilsItem] = contributions.compactMap { contribution in
                    return GoalDetilsItem(date: contribution.date, amount: contribution.amount, detailId: contribution.id, goalId: contribution.goal)
                }
                self?.input?.setDate(items)
            case .failure:
                break
            }
        }
    }
    
    func delete() {
        goalsService.deleteGoal(for: id)
        NotificationCenter.default.post(Notification(name: .delete))
    }
}

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

struct GoalDetailsItem: Hashable {
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
    private let output: GoalDetailsPresenterOutput
    private let goalsService: GoalsServiceProtocol
    private let contributinsService: ContributionsServiceProtocol
    private let fileStore: FileStoreProtocol
    private let notification = NotificationCenter.default
    private let id: UUID
    private var goalItems: [GoalDetailsItem] = []
    private var selectedId = UUID()
    
// MARK: - Lifecycle
    
    init(output: GoalDetailsPresenterOutput,
         goalsService: GoalsServiceProtocol,
         contributinsService: ContributionsServiceProtocol,
         fileStore: FileStoreProtocol,
         id: UUID) {
        self.output = output
        self.goalsService = goalsService
        self.contributinsService = contributinsService
        self.fileStore = fileStore
        self.id = id
        
        notification.addObserver(self, selector: #selector(updateGoal), name: .updateGoal, object: nil)
        notification.addObserver(self, selector: #selector(deleteGoal), name: .delete, object: nil)
    }
    
// MARK: - Helpers
    
    @objc private func updateGoal() {
        input?.showPopUp(.update)
    }
    
    @objc private func deleteGoal() {
        input?.showPopUp(.deleteGoal)
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
                        self?.selectedId = goal.id
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
                let items: [GoalDetailsItem] = contributions.compactMap { contribution in
                    return GoalDetailsItem(date: contribution.date, amount: contribution.amount, detailId: contribution.id, goalId: contribution.goal)
                }
                self?.goalItems = items
                self?.input?.setData(items)
            case .failure:
                break
            }
        }
    }
    
    func delete() {
        goalsService.deleteGoal(for: id)
    }
    
    func showEdit() {
        output.showGoalEditView(for: selectedId)
    }
    
    func showAddDetail() {
        output.showAddDetailView(for: selectedId)
    }
    
    func showAllDetails() {
        output.showAllDetailsView(goalItems: goalItems)
    }
}

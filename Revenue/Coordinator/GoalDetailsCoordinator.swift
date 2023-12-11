//
//  GoalDetailsCoordinator.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import UIKit

final class GoalDetailsCoordinator {
    
// MARK: - Properties
    
    private let goalsService: GoalsServiceProtocol
    private let contributionsService: ContributionsServiceProtocol
    private var navigation: UINavigationController?
    
// MARK: - Lifecycle
    
    init(goalsService: GoalsServiceProtocol, contributionsService: ContributionsServiceProtocol) {
        self.goalsService = goalsService
        self.contributionsService = contributionsService
    }
    
// MARK: - Helpers
    
    func start(id: UUID) -> UINavigationController {
        let presenter = GoalDetailsPresenter(output: self,
                                             goalsService: goalsService,
                                             contributinsService: contributionsService,
                                             id: id)
        let vc = GoalDetailsViewController(output: presenter)
        presenter.input = vc
        let nav = UINavigationController(rootViewController: vc)
        navigation = nav
        return nav
    }
}

// MARK: - GoalDetailsPresenterOutput

extension GoalDetailsCoordinator: GoalDetailsPresenterOutput {
    func showGoalEditView(for id: UUID) {
        let goalService = GoalsService(coreData: CoreDataService())
        let vc = GoalEditViewController(goalService: goalService, selectedId: id)
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showAddDetailView(for id: UUID) {
        let vc = AddDetail(id: id)
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showAllDetailsView(goalItems: [GoalDetailsItem]) {
        let presenter = ShowAllDetailsPresenter(output: self, goalItems: goalItems)
        let vc = ShowAllDetailsViewController(output: presenter)
        presenter.input = vc
        navigation?.pushViewController(vc, animated: true)
    }
}

// MARK: - ShowAllDetailsPresenterOutput

extension GoalDetailsCoordinator: ShowAllDetailsPresenterOutput {
    func showEditSelectedDetail(_ item: GoalDetailsItem) {
        let presenter = EditSelectedDetailPresenter(contributionsService: contributionsService, goalItem: item)
        let vc = EditSelectedDetail(output: presenter)
        presenter.input = vc
        navigation?.pushViewController(vc, animated: false)
    }
}

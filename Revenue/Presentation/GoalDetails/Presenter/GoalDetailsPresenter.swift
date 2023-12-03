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
}

final class GoalDetailsPresenter {
    
// MARK: - Properties
    
    weak var input: GoalDetailsInput?
    private let contributinsService: ContributionsServiceProtocol
    
// MARK: - Lifecycle
    
    init(contributinsService: ContributionsServiceProtocol) {
        self.contributinsService = contributinsService
    }
}

// MARK: - GoalDetaislOutput

extension GoalDetailsPresenter: GoalDetailsOutput {
    func viewIsReady() {
        contributinsService.fetchContributions(for: "123") { [weak self] result in
            switch result {
            case .success(let contributions):
                let items: [GoalDetilsItem] = contributions.compactMap { contribution in
                    return GoalDetilsItem(date: contribution.date, amount: contribution.amount)
                }
                self?.input?.setDate(items)
            case .failure:
                break
            }
        }
    }
}

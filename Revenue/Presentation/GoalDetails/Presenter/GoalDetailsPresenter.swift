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
    let amount: String
}

final class GoalDetailsPresenter {
    
// MARK: - Properties
    
    weak var input: GoalDetailsInput?
}

// MARK: - GoalDetaislOutput

extension GoalDetailsPresenter: GoalDetailsOutput {
    
}

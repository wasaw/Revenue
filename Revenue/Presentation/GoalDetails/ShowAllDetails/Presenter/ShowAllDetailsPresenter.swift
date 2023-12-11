//
//  ShowAllDetailsPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

final class ShowAllDetailsPresenter {
    
// MARK: - Properties
    
    weak var input: ShowAllDetailsInput?
    private let output: ShowAllDetailsPresenterOutput
    private let goalItems: [GoalDetailsItem]

// MARK: - Lifecycle
    
    init(output: ShowAllDetailsPresenterOutput, goalItems: [GoalDetailsItem]) {
        self.output = output
        self.goalItems = goalItems
    }
}

// MARK: - ShowAllDetailsOutput

extension ShowAllDetailsPresenter: ShowAllDetailsOutput {
    func viewIsReady() {
        input?.setData(goalItems)
    }
    
    func showDetailed(at index: Int) {
        output.showEditSelectedDetail(goalItems[index])
    }
}

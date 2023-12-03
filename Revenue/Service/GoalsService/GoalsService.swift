//
//  GoalsService.swift
//  Revenue
//
//  Created by Александр Меренков on 03.12.2023.
//

import Foundation

final class GoalsService {
    
// MARK: - Properties
    
    private let goals: [Goal] = [Goal(image: "goal1", title: "Накопить на машину", total: 40000000, isFinished: false),
                                 Goal(image: "goal1", title: "Ипотека", total: 7230000, isFinished: false),
                                 Goal(image: "goal1", title: "Телефон", total: 25000, isFinished: true)]
}

// MARK: - GoalsServiceProtocol

extension GoalsService: GoalsServiceProtocol {
    func fetchGoals(completion: @escaping (Result<[Goal], Error>) -> Void) {
        completion(.success(goals))
    }
}

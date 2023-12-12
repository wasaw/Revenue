//
//  GoalsServiceProtocol.swift
//  Revenue
//
//  Created by Александр Меренков on 03.12.2023.
//

import Foundation

protocol GoalsServiceProtocol: AnyObject {
    func fetchGoals(completion: @escaping (Result<[Goal], Error>) -> Void)
    func saveGoal(_ goal: Goal)
    func deleteGoal(for id: UUID)
    func update(_ goal: Goal)
}

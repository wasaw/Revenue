//
//  GoalsService.swift
//  Revenue
//
//  Created by Александр Меренков on 03.12.2023.
//

import Foundation

final class GoalsService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
}

// MARK: - GoalsServiceProtocol

extension GoalsService: GoalsServiceProtocol {
    func fetchGoals(completion: @escaping (Result<[Goal], Error>) -> Void) {
        do {
            let goalsManagedObject = try coreData.fetchGoals()
            let goals: [Goal] = goalsManagedObject.compactMap { managedObject in
                guard let id = managedObject.id,
                      let title = managedObject.title else { return nil }
                let contributionManagedObject = try? coreData.fetchContributions(id: id)
                var introduced: Double = 0
                contributionManagedObject?.forEach { contribution in
                    introduced += contribution.amount
                }
                return Goal(id: id,
                            image: "goal1",
                            title: title,
                            introduced: introduced,
                            total: managedObject.total,
                            isFinished: managedObject.isFinished)
            }
            completion(.success(goals))
        } catch {
            print(error)
        }
    }
}

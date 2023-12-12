//
//  GoalsService.swift
//  Revenue
//
//  Created by Александр Меренков on 03.12.2023.
//

import UIKit

final class GoalsService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    private let fileStore: FileStoreProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol, fileStore: FileStoreProtocol) {
        self.coreData = coreData
        self.fileStore = fileStore
    }
}

// MARK: - GoalsServiceProtocol

extension GoalsService: GoalsServiceProtocol {
    func fetchGoals(completion: @escaping (Result<[Goal], Error>) -> Void) {
        do {
            let goalsManagedObject = try coreData.fetchGoals()
            let goals: [Goal] = goalsManagedObject.compactMap { managedObject in
                guard let id = managedObject.id,
                      let title = managedObject.title,
                      let date = managedObject.date else { return nil }
                let contributionManagedObject  = managedObject.contributions?.array as? [ContributionManagedObject]
                var introduced: Double = 0
                contributionManagedObject?.forEach { contribution in
                    introduced += contribution.amount
                }
                
                guard let data = fileStore.fetchImage(id.uuidString),
                      let image = UIImage(data: data) else { return nil}
                
                return Goal(id: id,
                            image: image,
                            title: title,
                            introduced: introduced,
                            total: managedObject.total,
                            date: date,
                            isFinished: managedObject.isFinished)
            }
            completion(.success(goals))
        } catch {
            print(error)
        }
    }
    
    func saveGoal(_ goal: Goal) {
        coreData.save { context in
            let goalsManagedObject = GoalManagedObject(context: context)
            goalsManagedObject.id = goal.id
            goalsManagedObject.title = goal.title
            goalsManagedObject.total = goal.total
            goalsManagedObject.date = goal.date
            goalsManagedObject.isFinished = goal.isFinished
        }
        
        guard let data = goal.image.pngData() else { return }
        fileStore.saveImage(data: data, with: goal.id.uuidString) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteGoal(for id: UUID) {
        coreData.deleteGols(for: id)
    }
}

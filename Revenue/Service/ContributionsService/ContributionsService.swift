//
//  ContributionsService.swift
//  Revenue
//
//  Created by Александр Меренков on 03.12.2023.
//

import Foundation

final class ContributionsService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
}

// MARK: - ContributionsServiceProtocol

extension ContributionsService: ContributionsServiceProtocol {
    func fetchContributions(for id: UUID, completion: @escaping (Result<[Contribution], Error>) -> Void) {
        do {
            let goalManagedObject = try coreData.fetchContributions(id: id)
            guard let contributionManagedObject = goalManagedObject.first?.contributions?.array as? [ContributionManagedObject] else { return }
            
            let items: [Contribution] = contributionManagedObject.compactMap { managedObject in
                guard let date = managedObject.date,
                      let goal = managedObject.goal?.id,
                      let id = managedObject.id else { return nil }

                return Contribution(id: id,
                                    amount: managedObject.amount,
                                    date: date,
                                    goal: goal)
            }
            completion(.success(items))
        } catch {
            print(error)
        }
    }
    
    func saveContribution(_ item: Contribution) {
        coreData.save { context in
            let contributionManagedObject = ContributionManagedObject(context: context)
            contributionManagedObject.id = item.id
            contributionManagedObject.amount = item.amount
            contributionManagedObject.date = item.date
            let fetchRequest = GoalManagedObject.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.goal as CVarArg)
            let goalManagedObject = try context.fetch(fetchRequest).first
            goalManagedObject?.addToContributions(contributionManagedObject)
        }
    }
    
    func delete(for id: UUID) {
        coreData.deleteContributions(for: id)
    }
}

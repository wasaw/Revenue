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
            let contributionManagedObject = try coreData.fetchContributions(id: id)
            let items: [Contribution] = contributionManagedObject.compactMap { managedObject in
                guard let date = managedObject.date,
                      let goal = managedObject.goal else { return nil }
                return Contribution(amount: managedObject.amount,
                                    date: date,
                                    goal: goal)
            }
            completion(.success(items))
        } catch {
            print(error)
        }
    }
}

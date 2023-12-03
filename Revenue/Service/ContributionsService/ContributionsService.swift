//
//  ContributionsService.swift
//  Revenue
//
//  Created by Александр Меренков on 03.12.2023.
//

import Foundation

final class ContributionsService {
    
// MARK: - Properties
    
    private let contributions: [Contribution] = [Contribution(amount: 1000, date: Date(), goal: "123"),
                                                 Contribution(amount: 15000, date: Date(), goal: "123"),
                                                 Contribution(amount: 20000, date: Date(), goal: "11")]
}

// MARK: - ContributionsServiceProtocol

extension ContributionsService: ContributionsServiceProtocol {
    func fetchContributions(for id: String, completion: @escaping (Result<[Contribution], Error>) -> Void) {
        let items: [Contribution] = contributions.compactMap { contribution in
            if contribution.goal == id {
                return contribution
            }
            return nil
        }
        completion(.success(items))
    }
}

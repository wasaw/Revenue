//
//  ContributionsServiceProtocol.swift
//  Revenue
//
//  Created by Александр Меренков on 03.12.2023.
//

import Foundation

protocol ContributionsServiceProtocol: AnyObject {
    func fetchContributions(for id: String, completion: @escaping (Result<[Contribution], Error>) -> Void)
}

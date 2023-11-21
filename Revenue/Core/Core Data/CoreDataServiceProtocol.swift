//
//  CoreDataServiceProtocol.swift
//  Revenue
//
//  Created by Александр Меренков on 21.11.2023.
//

import CoreData

protocol CoreDataServiceProtocol: AnyObject {
    func save(completion: @escaping (NSManagedObjectContext) throws -> Void)
}

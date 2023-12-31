//
//  GoalDetailsOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 02.12.2023.
//

import Foundation

protocol GoalDetailsOutput: AnyObject {
    func viewIsReady()
    func delete()
    func showEdit()
    func showAddDetail()
    func showAllDetails()
}

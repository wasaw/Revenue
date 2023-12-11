//
//  ShowAllDetailsInput.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

protocol ShowAllDetailsInput: AnyObject {
    func setData(_ item: [GoalDetailsItem])
}

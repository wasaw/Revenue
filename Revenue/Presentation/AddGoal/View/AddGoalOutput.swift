//
//  AddGoalOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import UIKit

protocol AddGoalOutput: AnyObject {
    func setImage(_ image: UIImage)
    func save(title: String, introduced: Double, total: Double, date: Date)
}

//
//  SelectionDateOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 01.12.2023.
//

import Foundation

protocol SelectionDateOutput: AnyObject {
    func save(start: String, end: String)
}

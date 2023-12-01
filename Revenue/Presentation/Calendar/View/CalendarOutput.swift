//
//  CalendarOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 30.11.2023.
//

import Foundation

protocol CalendarOutput: AnyObject {
    func viewIsReady()
    func updateSelectedCell(at index: Int)
}

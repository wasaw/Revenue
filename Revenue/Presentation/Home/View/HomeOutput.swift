//
//  HomeOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import Foundation

protocol HomeOutput: AnyObject {
    func viewIsReady()
    func showDetails(at index: Int, in section: Int)
    func fetchData(for segment: Segment)
    func showCalendar()
    func showGoalDetails()
}

//
//  CalendarInput.swift
//  Revenue
//
//  Created by Александр Меренков on 30.11.2023.
//

import Foundation

protocol CalendarInput: AnyObject {
    func setCalendar(_ items: [CalendarItem])
    func hideCalendar()
}

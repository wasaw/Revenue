//
//  CalendarPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 30.11.2023.
//

import Foundation

enum CalendarSections: Hashable, CaseIterable {
    case section
}

struct CalendarItem: Hashable {
    let id = UUID()
    let title: String
    let isSelected: Bool
}

final class CalendarPresenter {
    
// MARK: - Properties
    
    weak var input: CalendarInput?
    
}

// MARK: - CalendarOutput

extension CalendarPresenter: CalendarOutput {
    func viewIsReady() {
        let calendarItems = [CalendarItem(title: "За неделю", isSelected: true),
                             CalendarItem(title: "За неделю", isSelected: false),
                             CalendarItem(title: "За полгода", isSelected: false),
                             CalendarItem(title: "Другое", isSelected: false)]
        input?.setCalendar(calendarItems)
    }
}

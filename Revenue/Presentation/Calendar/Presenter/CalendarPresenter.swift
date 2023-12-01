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
    var isSelected: Bool
}

final class CalendarPresenter {
    
// MARK: - Properties
    
    weak var input: CalendarInput?
    private let output: CalendarPresenterOutput
    private var calendarItems: [CalendarItem]
    
// MARK: - Lifecycle
    
    init(output: CalendarPresenterOutput) {
        self.output = output
        self.calendarItems = [CalendarItem(title: "За неделю", isSelected: true),
                              CalendarItem(title: "За месяц", isSelected: false),
                              CalendarItem(title: "За полгода", isSelected: false),
                              CalendarItem(title: "Другое", isSelected: false)]
    }
    
}

// MARK: - CalendarOutput

extension CalendarPresenter: CalendarOutput {
    func viewIsReady() {
        input?.setCalendar(calendarItems)
    }
    
    func updateSelectedCell(at index: Int) {
        for (indexFor, _) in calendarItems.enumerated() {
            if indexFor == index {
                calendarItems[indexFor].isSelected = true
            } else {
                calendarItems[indexFor].isSelected = false
            }
        }
        if calendarItems.last?.isSelected == true {
            input?.hideCalendar()
            output.showSelectionDate()
        } else {
            input?.setCalendar(calendarItems)
        }
    }
}

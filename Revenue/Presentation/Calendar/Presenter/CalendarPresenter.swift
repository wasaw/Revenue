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
    
    func saveValue() {
        for (index, item) in calendarItems.enumerated() {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.YYYY"
            if item.isSelected {
                switch index {
                case 0:
                    let cal = Calendar.current
                    var comp = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date())
                    comp.weekday = 2
                    guard let monday = cal.date(from: comp) else { return }
                    let start = formatter.string(from: monday)
                    let end = formatter.string(from: Date())
                    UserDefaults.standard.set(start, forKey: "startTime")
                    UserDefaults.standard.set(end, forKey: "endTime")
                case 1:
                    let month = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
                    let start = formatter.string(from: month)
                    let end = formatter.string(from: Date())
                    UserDefaults.standard.set(start, forKey: "startTime")
                    UserDefaults.standard.set(end, forKey: "endTime")
                case 2:
                    let month = Calendar.current.date(byAdding: .day, value: -180, to: Date()) ?? Date()
                    let start = formatter.string(from: month)
                    let end = formatter.string(from: Date())
                    UserDefaults.standard.set(start, forKey: "startTime")
                    UserDefaults.standard.set(end, forKey: "endTime")
                default:
                    break
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name("updateTime"), object: nil)
    }
}

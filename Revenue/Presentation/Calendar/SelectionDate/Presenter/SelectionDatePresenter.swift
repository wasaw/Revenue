//
//  SelectionDatePresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 01.12.2023.
//

import Foundation

final class SelectionDatePresenter {
    
// MARK: - Properties
    
    weak var input: SelectionDateInput?
}

// MARK: - SelectionDateOutput

extension SelectionDatePresenter: SelectionDateOutput {
    func save(start: String, end: String) {
        UserDefaults.standard.set(start, forKey: "startTime")
        UserDefaults.standard.set(end, forKey: "endTime")
        NotificationCenter.default.post(name: Notification.Name("updateTime"), object: nil)
    }
}

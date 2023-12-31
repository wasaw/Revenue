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
    func save(start: Date, finish: Date) {
        NotificationCenter.default.post(name: .updateTime, object: nil)
    }
}

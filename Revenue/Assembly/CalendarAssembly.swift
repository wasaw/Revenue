//
//  CalendarAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 01.12.2023.
//

import UIKit

final class CalendarAssembly {
    func makeShowCalendarModule() -> UIViewController {
        let presenter = CalendarPresenter()
        let vc = CalendarViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}

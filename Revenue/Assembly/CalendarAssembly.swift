//
//  CalendarAssembly.swift
//  Revenue
//
//  Created by Александр Меренков on 01.12.2023.
//

import UIKit

final class CalendarAssembly {
    func makeShowCalendarModule(output: CalendarPresenterOutput) -> UIViewController {
        let presenter = CalendarPresenter(output: output)
        let vc = CalendarViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}

//
//  EditSelectedDetailOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

protocol EditSeelctedDetailOutput: AnyObject {
    func viewIsReady()
    func save(_ amount: Double)
    func delete()
}

//
//  HomeOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import Foundation

protocol HomeOutput: AnyObject {
    func viewIsReady()
    func showDetails(for index: Int, in section: Int)
}

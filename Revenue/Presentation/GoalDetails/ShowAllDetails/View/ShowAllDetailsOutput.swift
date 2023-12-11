//
//  ShowAllDetailsOutput.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import Foundation

protocol ShowAllDetailsOutput: AnyObject {
    func viewIsReady()
    func showDetailed(at index: Int)
}

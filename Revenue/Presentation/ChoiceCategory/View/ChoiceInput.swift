//
//  ChoiceInput.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import Foundation

protocol ChoiceInput: AnyObject {
    func setCategories(_ items: [TableCategoryItem])
    func showSegmentControlelr(isHidden: Bool)
}

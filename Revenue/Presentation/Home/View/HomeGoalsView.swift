//
//  HomeGoalsView.swift
//  Revenue
//
//  Created by Александр Меренков on 22.11.2023.
//

import UIKit

final class HomeGoalsView: UIView {
    
// MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

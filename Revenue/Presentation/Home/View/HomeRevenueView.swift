//
//  HomeRevenueView.swift
//  Revenue
//
//  Created by Александр Меренков on 22.11.2023.
//

import UIKit
import SnapKit

final class HomeRevenueView: UIView {
    
// MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
//        configureUI()
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

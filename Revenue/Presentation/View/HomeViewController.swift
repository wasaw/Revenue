//
//  HomeViewController.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: HomeOutputProtocol
    
// MARK: - Lifecycle
    
    init(output: HomeOutputProtocol) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
    }
}

// MARK: - HomeInputProtocol

extension HomeViewController: HomeInputProtocol {
    
}

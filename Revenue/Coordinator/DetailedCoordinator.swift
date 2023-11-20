//
//  DetailedCoordinator.swift
//  Revenue
//
//  Created by Александр Меренков on 18.11.2023.
//

import UIKit

final class DetailedCordinator {
    
// MARK: - Properties
    
    private let detailedAssembly: DetailedTransactionAssembly
    private let choiceCategoryAsembly: ChoiceCategoryAssembly
    private var presenterViewController: UIViewController?
    
// MARK: - Lifecycle
    
    init(detailedAssembly: DetailedTransactionAssembly, choiceCategoryAssembly: ChoiceCategoryAssembly) {
        self.detailedAssembly = detailedAssembly
        self.choiceCategoryAsembly = choiceCategoryAssembly
    }
    
// MARK: - Helpers
    
    func start() -> UIViewController {
        let vc = detailedAssembly.makeDetailedModule(output: self)
        presenterViewController = vc
        return vc
    }
}

// MARK: - DetailedPresenserOutput

extension DetailedCordinator: DetailedPresenterOutput {
    func showChoiceCategory() {
        let vc = choiceCategoryAsembly.makeDetailedModule()
        vc.modalPresentationStyle = .overCurrentContext
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        let topMostViewController = window.rootViewController
        topMostViewController?.present(vc, animated: false)
    }
}

//
//  SceneDelegate.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

// MARK: - Properties
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let detailedAssembly = DetailedTransactionAssembly()
        let choiceCategoryAssembly = ChoiceCategoryAssembly()
        let detailedCoordinator = DetailedCoordinator(detailedAssembly: detailedAssembly, choiceCategoryAssembly: choiceCategoryAssembly)
        
        let coreData = CoreDataService()
        let transactionService = TransactionsService(coreData: coreData)
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let homeCoordinator = HomeCoordinator(detailedCoordinator: detailedCoordinator, transactionService: transactionService)
        window?.rootViewController = homeCoordinator.start()
        window?.makeKeyAndVisible()
    }
}


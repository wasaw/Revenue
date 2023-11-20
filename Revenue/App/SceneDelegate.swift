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
        let detailedCoordinator = DetailedCordinator(detailedAssembly: detailedAssembly, choiceCategoryAssembly: choiceCategoryAssembly)
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let homeCoordinator = HomeCoordinator(detailedCoordinator: detailedCoordinator)
        window?.rootViewController = homeCoordinator.start()
        window?.makeKeyAndVisible()
    }
}


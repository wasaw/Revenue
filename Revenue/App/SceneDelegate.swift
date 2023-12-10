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
        let showTransactionsAssembly = ShowTransactionsAssembly()
        let calendarAssembly = CalendarAssembly()
        
        let coreData = CoreDataService.shared
        let transactionService = TransactionsService(coreData: coreData)
        let categoriesService = CategoriesService(coreData: coreData)
        let goalService = GoalsService(coreData: coreData)
        let contributionsService = ContributionsService(coreData: coreData)
        
        let detailedCoordinator = DetailedCoordinator(detailedAssembly: detailedAssembly,
                                                      choiceCategoryAssembly: choiceCategoryAssembly,
                                                      categoriesService: categoriesService,
                                                      transactionsService: transactionService)

        if UserDefaults.standard.value(forKey: "isFirstLaunce") == nil {
            let defaultService = DefaultValueService(coreData: coreData)
            defaultService.saveValues()
            UserDefaults.standard.set(false, forKey: "isFirstLaunce")
        }
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let homeCoordinator = HomeCoordinator(detailedCoordinator: detailedCoordinator,
                                              choiceCategoryAssembly: choiceCategoryAssembly,
                                              showTransactionsAssembly: showTransactionsAssembly,
                                              calendarAssembly: calendarAssembly,
                                              transactionService: transactionService,
                                              categoriesService: categoriesService,
                                              goalService: goalService,
                                              contributionsService: contributionsService)
        window?.rootViewController = homeCoordinator.start()
        window?.makeKeyAndVisible()
    }
}


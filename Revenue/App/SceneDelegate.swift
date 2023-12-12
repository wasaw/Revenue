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
        
// MARK: - Assembly
        
        let detailedAssembly = DetailedTransactionAssembly()
        let choiceCategoryAssembly = ChoiceCategoryAssembly()
        let showTransactionsAssembly = ShowTransactionsAssembly()
        let calendarAssembly = CalendarAssembly()
        
// MARK: - Service
        let coreData = CoreDataService.shared
        let transactionService = TransactionsService(coreData: coreData)
        let categoriesService = CategoriesService(coreData: coreData)
        let fileStore = FileStore()
        let goalService = GoalsService(coreData: coreData, fileStore: fileStore)
        let contributionsService = ContributionsService(coreData: coreData)
        
// MARK: - Coordinator
        
        let detailedCoordinator = DetailedCoordinator(detailedAssembly: detailedAssembly,
                                                      choiceCategoryAssembly: choiceCategoryAssembly,
                                                      categoriesService: categoriesService,
                                                      transactionsService: transactionService)
        let goalDetailsCoordinator = GoalDetailsCoordinator(goalsService: goalService,
                                                            contributionsService: contributionsService,
                                                            fileStore: fileStore)

        if UserDefaults.standard.value(forKey: "isFirstLaunce") == nil {
            let defaultService = DefaultValueService(coreData: coreData, fileStore: fileStore)
            defaultService.saveValues()
            UserDefaults.standard.set(false, forKey: "isFirstLaunce")
        }
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let homeCoordinator = HomeCoordinator(detailedCoordinator: detailedCoordinator,
                                              goalDetailsCoordinator: goalDetailsCoordinator,
                                              choiceCategoryAssembly: choiceCategoryAssembly,
                                              showTransactionsAssembly: showTransactionsAssembly,
                                              calendarAssembly: calendarAssembly,
                                              transactionService: transactionService,
                                              categoriesService: categoriesService,
                                              goalService: goalService,
                                              contributionsService: contributionsService,
                                              fileStore: fileStore)
        window?.rootViewController = homeCoordinator.start()
        window?.makeKeyAndVisible()
    }
}


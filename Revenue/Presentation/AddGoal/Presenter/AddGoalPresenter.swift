//
//  AddGoalPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 11.12.2023.
//

import UIKit

final class AddGoalPresenter {
    
// MARK: - Properties
    
    weak var input: AddGoalInput?
    private let goalService: GoalsServiceProtocol
    private let fileStore: FileStoreProtocol
    private var saveImage = UIImage(named: "goal1")
    
    init(goalService: GoalsServiceProtocol, fileStore: FileStoreProtocol) {
        self.goalService = goalService
        self.fileStore = fileStore
    }
}

// MARK: - AddGoalOutput

extension AddGoalPresenter: AddGoalOutput {
    func setImage(_ image: UIImage) {
        saveImage = image
    }
    
    func save(title: String, introduced: Double, total: Double, date: Date) {
        let id = UUID()
        if let data = saveImage?.pngData() {
            fileStore.saveImage(data: data, with: id.uuidString) { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        goalService.saveGoal(Goal(id: id,
                                  image: UIImage(),
                                  title: title,
                                  introduced: introduced,
                                  total: total,
                                  date: date,
                                  isFinished: false))
        NotificationCenter.default.post(Notification(name: .addGoal))
    }
}

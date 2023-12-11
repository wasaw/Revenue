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
    private var saveImage = UIImage(named: "goal1")
    
    init(goalService: GoalsServiceProtocol) {
        self.goalService = goalService
    }
}

// MARK: - AddGoalOutput

extension AddGoalPresenter: AddGoalOutput {
    func setImage(_ image: UIImage) {
        saveImage = image
    }
    
    func save(title: String, introduced: Double, total: Double, date: Date) {
        let id = UUID()
        
        guard let directlyUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = directlyUrl.appendingPathComponent(id.uuidString)
        do {
            if let data = saveImage?.pngData() {
                try data.write(to: fileUrl)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        goalService.saveGoal(Goal(id: id,
                                  image: id.uuidString,
                                  title: title,
                                  introduced: introduced,
                                  total: total,
                                  date: date,
                                  isFinished: false))
        NotificationCenter.default.post(Notification(name: .addGoal))
    }
}

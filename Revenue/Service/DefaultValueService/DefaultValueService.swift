//
//  DefaultValueService.swift
//  Revenue
//
//  Created by Александр Меренков on 21.11.2023.
//

import UIKit

final class DefaultValueService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    private let userDefaults = UserDefaults.standard
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol) {
        self.coreData = coreData
    }
}

// MARK: - DefaultValueServiceProtocol

extension DefaultValueService: DefaultValueServiceProtocol {
    func saveValues() {
        
        let salaryCategory = TransactionCategory(image: "salary", title: "Заработная плата", isRevenue: true)
        let businessCategory = TransactionCategory(image: "business", title: "Доходы от бизнеса", isRevenue: true)
        let creditCategory = TransactionCategory(image: "credit", title: "Кредит/Долг", isRevenue: true)
        let depositeCategory = TransactionCategory(image: "deposit", title: "Депозит", isRevenue: true)
        let grantCategory = TransactionCategory(image: "grant", title: "Стипендия", isRevenue: true)
        let capitalCategory = TransactionCategory(image: "capital", title: "Сбережения", isRevenue: true)
        let medicineCategory = TransactionCategory(image: "medicine", title: "Медицина", isRevenue: false)
        let transportCategory = TransactionCategory(image: "transport", title: "Транспорт", isRevenue: false)
        let utilitiesCategory = TransactionCategory(image: "utilities", title: "Коммунальные услуги", isRevenue: false)
        let loanCategory = TransactionCategory(image: "loan", title: "Деньги взаймы", isRevenue: false)
        let cafeCategory = TransactionCategory(image: "cafe", title: "Кафе и рестораны", isRevenue: false)
        let entertainmentCategory = TransactionCategory(image: "entertainment", title: "Резвлечения", isRevenue: false)
        let otherCategory = TransactionCategory(image: "other", title: "Другое", isRevenue: true)
        let otherCategoryFalse = TransactionCategory(image: "other", title: "Другое ", isRevenue: false)
        
        let categories: [TransactionCategory] = [salaryCategory,
                                                 businessCategory,
                                                 creditCategory,
                                                 depositeCategory,
                                                 grantCategory,
                                                 capitalCategory,
                                                 medicineCategory,
                                                 transportCategory,
                                                 utilitiesCategory,
                                                 loanCategory,
                                                 cafeCategory,
                                                 entertainmentCategory,
                                                 otherCategory,
                                                 otherCategoryFalse]
        
        let transactions = [Transaction(id: UUID(), category: salaryCategory, amount: 90000, comment: "Зарплата", date: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: salaryCategory, amount: 7200, comment: "", date: Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: medicineCategory, amount: 27000, comment: "", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: transportCategory, amount: 2500, comment: "", date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: utilitiesCategory, amount: 20000, comment: "", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: loanCategory, amount: 15000, comment: "", date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: cafeCategory, amount: 30000, comment: "Обед", date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: entertainmentCategory, amount: 23000, comment: "", date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: salaryCategory, amount: 30000, comment: "Аванс", date: Calendar.current.date(byAdding: .day, value: -9, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: salaryCategory, amount: 1200, comment: "", date: Calendar.current.date(byAdding: .day, value: -9, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: salaryCategory, amount: 170000, comment: "Премия", date: Calendar.current.date(byAdding: .day, value: -9, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: salaryCategory, amount: 2000, comment: "", date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: businessCategory, amount: 323100, comment: "", date: Calendar.current.date(byAdding: .day, value: -11, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: depositeCategory, amount: 27102, comment: "", date: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: capitalCategory, amount: 2139222, comment: "", date: Calendar.current.date(byAdding: .day, value: -25, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: grantCategory, amount: 1000, comment: "", date: Calendar.current.date(byAdding: .day, value: -40, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: salaryCategory, amount: 23133, comment: "", date: Calendar.current.date(byAdding: .day, value: -45, to: Date()) ?? Date()),
                            Transaction(id: UUID(), category: creditCategory, amount: 15000, comment: "Машина", date: Calendar.current.date(byAdding: .day, value: -80, to: Date()) ?? Date())]

        categories.forEach { category in
            coreData.save { context in
                let categoryManagedObject = CategoryManagedObject(context: context)
                categoryManagedObject.title = category.title
                categoryManagedObject.image = category.image
                categoryManagedObject.isRevenue = category.isRevenue
                var total: Double = 0
                transactions.forEach { transaction in
                    guard transaction.category.title == category.title else { return }
                    let transactionManagedObject = TransactionManagedObject(context: context)
                    transactionManagedObject.id = transaction.id
                    transactionManagedObject.amount = transaction.amount
                    transactionManagedObject.comment = transaction.comment
                    transactionManagedObject.date = transaction.date
                    categoryManagedObject.addToTransactions(transactionManagedObject)
                    total += transaction.amount
                }
                categoryManagedObject.total = total
            }
        }
        
        let id1 = UUID()
        let id2 = UUID()
        let id3 = UUID()
        let goals: [Goal] = [Goal(id: id1, image: id1.uuidString, title: "Накопить на машину", introduced: 0, total: 40000000, date: Date(), isFinished: false),
                             Goal(id: id2, image: id2.uuidString, title: "Ипотека", introduced: 0, total: 7230000, date: Date(), isFinished: false),
                             Goal(id: id3, image: id3.uuidString, title: "Телефон", introduced: 0, total: 25000, date: Date(), isFinished: true)]
        
        let contributions: [Contribution] = [Contribution(id: UUID(), amount: 1000, date: Date(), goal: id1),
                                             Contribution(id: UUID(), amount: 5000, date: Date(), goal: id1),
                                             Contribution(id: UUID(), amount: 300, date: Date(), goal: id1),
                                             Contribution(id: UUID(), amount: 15000, date: Date(), goal: id1),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -11, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -8, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -9, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -11, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -13, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 20000, date: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date(), goal: id2),
                                             Contribution(id: UUID(), amount: 25000, date: Date(), goal: id3)]
        
        goals.forEach { goal in
            coreData.save { context in
                let goalManagedObject = GoalManagedObject(context: context)
                goalManagedObject.id = goal.id
                goalManagedObject.title = goal.title
                goalManagedObject.total = goal.total
                goalManagedObject.date = goal.date
                goalManagedObject.isFinished = goal.isFinished
            }
        }
        
        contributions.forEach { contribution in
            coreData.save { context in
                let contributonManagedObject = ContributionManagedObject(context: context)
                contributonManagedObject.id = contribution.id
                contributonManagedObject.amount = contribution.amount
                contributonManagedObject.date = contribution.date
                contributonManagedObject.goal = contribution.goal
            }
        }
        
        goals.forEach { goal in
            guard let directlyUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileUrl = directlyUrl.appendingPathComponent(goal.id.uuidString)
            do {
                if let data = UIImage(named: "goal1")!.pngData() {
                    try data.write(to: fileUrl)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let nowDay = Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date()
        let month = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
        userDefaults.set(month, forKey: DefaultsValues.startDate)
        userDefaults.set(nowDay, forKey: DefaultsValues.finishDate)
    }
}

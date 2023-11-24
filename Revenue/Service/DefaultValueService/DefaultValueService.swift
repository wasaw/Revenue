//
//  DefaultValueService.swift
//  Revenue
//
//  Created by Александр Меренков on 21.11.2023.
//

import Foundation

final class DefaultValueService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    
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
                                                 entertainmentCategory]
        
        let transactions = [Transaction(category: salaryCategory, amount: 90000, comment: "", date: Date()),
                            Transaction(category: medicineCategory, amount: 27000, comment: "", date: Date()),
                            Transaction(category: transportCategory, amount: 2500, comment: "", date: Date()),
                            Transaction(category: utilitiesCategory, amount: 20000, comment: "", date: Date()),
                            Transaction(category: loanCategory, amount: 15000, comment: "", date: Date()),
                            Transaction(category: cafeCategory, amount: 30000, comment: "", date: Date()),
                            Transaction(category: entertainmentCategory, amount: 23000, comment: "", date: Date()),
                            Transaction(category: salaryCategory, amount: 30000, comment: "", date: Date()),
                            Transaction(category: salaryCategory, amount: 2000, comment: "", date: Date()),
                            Transaction(category: businessCategory, amount: 323100, comment: "", date: Date()),
                            Transaction(category: depositeCategory, amount: 27102, comment: "", date: Date()),
                            Transaction(category: capitalCategory, amount: 2139222, comment: "", date: Date()),
                            Transaction(category: grantCategory, amount: 1000, comment: "", date: Date()),
                            Transaction(category: salaryCategory, amount: 23133, comment: "", date: Date()),
                            Transaction(category: creditCategory, amount: 15000, comment: "", date: Date())]

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
                    transactionManagedObject.amount = transaction.amount
                    transactionManagedObject.comment = transaction.comment
                    transactionManagedObject.date = transaction.date
                    categoryManagedObject.addToTransactions(transactionManagedObject)
                    total += transaction.amount
                }
                categoryManagedObject.total = total
            }
        }
    }
}

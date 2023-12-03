//
//  HomePresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 15.11.2023.
//

import Foundation

struct HomeTransactions {
    let sections: [String]
    let item: [HomeRemainsItem]
}

struct HomeRemainsItem: Hashable {
    let id = UUID()
    let image: String
    let title: String
    let amount: Double
    let time: String
    let isRevenue: Bool
}

enum HomeRevenueSections: Hashable, CaseIterable {
    case section
}

struct HomeRevenueItem: Hashable {
    let id = UUID()
    let image: String
    let title: String
    let amount: Double
    let percent: Double
    let isRevenue: Bool
}

enum HomeGoalsSections: Hashable, CaseIterable {
    case section
}

struct HomeGoalsItem: Hashable {
    let id = UUID()
    let image: String
    let title: String
    let introduced: Double
    let total: Double
}

enum Segment: Int {
    case remains
    case revenue
    case expenses
    case goals
}

struct Expense {
    let category: Category
    var amount: Double
}

var sectionsArray: [String] = []

final class HomePresenter {
    
// MARK: - Properties
    
    weak var input: HomeInputProtocol?
    private let output: HomePresenterOutput
    private let transactionService: TransactionsServiceProtocol
    private let categoriesService: CategoriesServiceProtocol
    private let goalService: GoalsServiceProtocol
    
    private var selectedTransactions: [Transaction] = []
    private var revenueCategories: [TransactionCategory] = []
    private var isFinishedGoals: [Goal] = []
    private var isNotFinishedGoals: [Goal] = []
    private let dateFormatter = DateFormatter()
    private let dayDateFormatter = DateFormatter()

// MARK: - Lifecycle
    
    init(output: HomePresenterOutput,
         transactionService: TransactionsServiceProtocol,
         categoriesService: CategoriesServiceProtocol,
         goalService: GoalsServiceProtocol) {
        self.output = output
        self.transactionService = transactionService
        self.categoriesService = categoriesService
        self.goalService = goalService
        
        dateFormatter.dateFormat = "HH:mm"
        dayDateFormatter.dateFormat = "dd.MM.YYYY"
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTime), name: Notification.Name("updateTime"), object: nil)
    }
    
    private func setCurrentDate() {
        let nowDay = Calendar.current.date(byAdding: .day, value: 0, to: Date()) ?? Date()
        let month = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
        input?.setCalendarDate(from: dayDateFormatter.string(from: month), to: dayDateFormatter.string(from: nowDay))
    }
    
// MARK: - Selecter
    
    @objc private func updateTime() {
        guard let start = UserDefaults.standard.value(forKey: "startTime") as? String,
              let end = UserDefaults.standard.value(forKey: "endTime") as? String else { return }
        input?.setCalendarDate(from: start, to: end)
    }
}

// MARK: HomeOutputProtocol

extension HomePresenter: HomeOutput {
    func viewIsReady() {
        setCurrentDate()
        let total = categoriesService.fetchTotalAmount()
        transactionService.fetchTransactions { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.selectedTransactions = transactions
                var dateArray: [String] = []
                var homeTransactions: [HomeTransactions] = []
                transactions.forEach { transaction in
                    guard let day = self?.dayDateFormatter.string(from: transaction.date) else { return }
                    if dateArray.isEmpty {
                        dateArray.append(day)
                    } else {
                        let last = dateArray.last
                        if last != day {
                            dateArray.append(day)
                        }
                    }
                }
                sectionsArray = dateArray
                dateArray.forEach { dateItem in
                    var items: [HomeRemainsItem] = []
                    transactions.forEach { transaction in
                        let day = self?.dayDateFormatter.string(from: transaction.date)
                        if dateItem == day {
                            guard let date = self?.dateFormatter.string(from: transaction.date) else { return }
                            let element = HomeRemainsItem(image: transaction.category.image,
                                                          title: transaction.category.title,
                                                          amount: transaction.amount,
                                                          time: date,
                                                          isRevenue: transaction.category.isRevenue)
                            items.append(element)
                        }
                    }
                    let homeTransactionElement = HomeTransactions(sections: [dateItem], item: items)
                    homeTransactions.append(homeTransactionElement)
                }
                self?.input?.setTransactions(for: homeTransactions, total: total)
            case .failure:
                break
            }
        }
    }
    
    func showDetails(at index: Int, in section: Int) {
        let transaction = selectedTransactions[index]
        output.showDetailed(for: transaction)
    }
    
    func fetchData(for segment: Segment) {
        switch segment {
        case .remains:
            break
        case .revenue:
            categoriesService.fetchCategories(isRevenue: true) { [weak self] result in
                switch result {
                case .success(let tuple):
                    self?.revenueCategories = []
                    let items = tuple.categories.compactMap { [weak self] category in
                        self?.revenueCategories.append(category)
                        return HomeRevenueItem(image: category.image,
                                               title: category.title,
                                               amount: category.total,
                                               percent: ((category.total / tuple.total) * 100),
                                               isRevenue: category.isRevenue)
                    }
                    self?.input?.setRevenue(items)
                case .failure:
                    break
                }
            }
        case .expenses:
            categoriesService.fetchCategories(isRevenue: false) { [weak self] result in
                switch result {
                case .success(let tuple):
                    self?.revenueCategories = []
                    let items = tuple.categories.compactMap { [weak self] category in
                        self?.revenueCategories.append(category)
                        return HomeRevenueItem(image: category.image,
                                               title: category.title,
                                               amount: category.total,
                                               percent: ((category.total / tuple.total) * 100),
                                               isRevenue: category.isRevenue)
                    }
                    self?.input?.setRevenue(items)
                case .failure:
                    break
                }
            }
        case .goals:
            goalService.fetchGoals { [weak self] result in
                switch result {
                case .success(let goals):
                    self?.isFinishedGoals = []
                    self?.isNotFinishedGoals = []
                    var introduce: Double = 0
                    let items: [HomeGoalsItem] = goals.compactMap { goal in
                        introduce += goal.introduced
                        if goal.isFinished == false {
                            self?.isNotFinishedGoals.append(goal)
                            return HomeGoalsItem(image: goal.id.uuidString,
                                                 title: goal.title,
                                                 introduced: goal.introduced,
                                                 total: goal.total)
                        }
                        self?.isFinishedGoals.append(goal)
                        return nil
                    }
                    self?.input?.setGoals(items, total: introduce)
                case .failure:
                    break
                }
            }
        }
    }
    
    func showCalendar() {
        output.showCalendar()
    }
    
    func showAddGoal() {
        output.showAddGoal()
    }
    
    func fetchGoals(isFinished: Bool) {
        goalService.fetchGoals { [weak self] result in
            switch result {
            case .success(let goals):
                var introduce: Double = 0
                let items: [HomeGoalsItem] = goals.compactMap { goal in
                    introduce += goal.introduced
                    if goal.isFinished == isFinished {
                        return HomeGoalsItem(image: goal.id.uuidString,
                                             title: goal.title,
                                             introduced: goal.introduced,
                                             total: goal.total)
                    }
                    return nil
                }
                self?.input?.setGoals(items, total: introduce)
            case .failure:
                break
            }
        }
    }
}

// MARK: - HomeRevenueOutput

extension HomePresenter: HomeTransactionsOutput {
    func showAddTransaction() {
        output.showAddTransaction(isRevenue: revenueCategories[0].isRevenue)
    }
    
    func showDetails(at index: Int) {
        output.showShowTransactions(for: revenueCategories[index])
    }
    
    func showGoalDetails(for section: Int, at index: Int) {
        if section == 0 {
            output.showGoalDetails(id: isNotFinishedGoals[index].id)
        } else {
            output.showGoalDetails(id: isFinishedGoals[index].id)
        }
    }
}

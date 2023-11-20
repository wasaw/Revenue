//
//  DetailedTransactionPresenter.swift
//  Revenue
//
//  Created by Александр Меренков on 17.11.2023.
//

import Foundation

final class DetailedTransactionPresenter {
    
// MARK: - Properties
    
    weak var input: DetailedTransactionInput?
    private let output: DetailedPresenterOutput
    
// MARK: - Lifecycle
    
    init(output: DetailedPresenterOutput) {
        self.output = output
    }
}

// MARK: - DetailedTransactionOutput

extension DetailedTransactionPresenter: DetailedTransactionOutput {
    func showChoiceCategory() {
        output.showChoiceCategory()
    }
}

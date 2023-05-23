//
//  FoodOverviewInteractor.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import Foundation

protocol FoodOverviewInteracting {
    func organizeFoodInfo(request: FoodOverview.LoadInfo.Request)
}

final class FoodOverviewInteractor: FoodOverviewInteracting {
    private let presenter: FoodOverviewPresenting

    init(presenter: FoodOverviewPresenting) {
        self.presenter = presenter
    }
    
    func organizeFoodInfo(request: FoodOverview.LoadInfo.Request) {
        presenter.presentFoodOverview(response: .init(food: request.food))
    }
}

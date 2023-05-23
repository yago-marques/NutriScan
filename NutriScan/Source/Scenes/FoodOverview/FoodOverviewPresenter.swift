//
//  FoodOverviewPresenter.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import Foundation

protocol FoodOverviewPresenting {
    func presentFoodOverview(response: FoodOverview.LoadInfo.Response)
}

final class FoodOverviewPresenter: FoodOverviewPresenting {
    weak var controller: FoodOverviewControlling?

    init(controller: FoodOverviewControlling? = nil) {
        self.controller = controller
    }

    func presentFoodOverview(response: FoodOverview.LoadInfo.Response) {
        controller?.displayOverview(viewModel: .init(food: response.food))
    }
}

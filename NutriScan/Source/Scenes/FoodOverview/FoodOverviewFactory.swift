//
//  FoodOverviewFactory.swift
//  NutriScan
//
//  Created by Yago Marques on 15/05/23.
//

import UIKit

enum FoodOverviewFactory {
    static func make(with food: Food) -> UIViewController {
        let view = FoodOverviewView(frame: UIScreen.main.bounds)
        let presenter = FoodOverviewPresenter()
        let interactor = FoodOverviewInteractor(presenter: presenter)
        let controller = FoodOverviewController(
            foodOverview: view,
            food: food,
            interactor: interactor
        )

        view.controller = controller
        presenter.controller = controller

        return controller
    }
}

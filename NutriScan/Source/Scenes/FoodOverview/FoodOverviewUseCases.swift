//
//  FoodOverviewUseCases.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import Foundation

enum FoodOverview {
    enum LoadInfo {
        struct Request {
            let food: Food
        }

        struct Response {
            let food: Food
        }

        struct ViewModel {
            let food: Food
        }
    }
}

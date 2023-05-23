//
//  FoodOverview.swift
//  NutriScan
//
//  Created by Yago Marques on 08/05/23.
//

import Foundation

struct Food {
    let name: String
    let category: String
    let itens: [FoodOverviewItem]

    struct FoodOverviewItem {
        let title: String
        let description: String
    }
}

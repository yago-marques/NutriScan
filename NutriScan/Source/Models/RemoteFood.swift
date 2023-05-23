//
//  RemoteFood.swift
//  NutriScan
//
//  Created by Yago Marques on 08/05/23.
//

import Foundation

struct RemoteFood: Codable {
    let name: String
    let category: String
    let itens: [RemoteOverviewFoodItem]

    struct RemoteOverviewFoodItem: Codable {
        let title: String
        let description: String
    }
}

//
//  FoodMapper.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import Foundation

struct FoodMapper {
    static func toViewModel(from remoteModel: RemoteFood) -> Food {
        .init(
            name: remoteModel.name,
            category: remoteModel.category,
            itens: remoteModel.itens
                .map { Food.FoodOverviewItem(title: $0.title, description: $0.description) }
        )
    }
}

//
//  EmptyListNotificationComposer.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import Foundation

enum EmptyListNotificationComposer {
    static func make() -> GenericErrorViewModel {
        .init(
            title: "Lista vazia",
            message: "Nenhum item foi encontrado na pesquisa",
            image: "eye.slash"
        )
    }
}

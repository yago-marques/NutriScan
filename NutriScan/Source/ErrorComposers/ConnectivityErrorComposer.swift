//
//  ConnectivityErrorComposer.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import Foundation

enum ConnectivityErrorComposer {
    static func make() -> GenericErrorViewModel {
        .init(
            title: "Erro de Conexão",
            message: "Houve um error de conexão com a internet, verifique sua conexão e tente outra vez",
            image: "wifi.slash"
        )
    }
}

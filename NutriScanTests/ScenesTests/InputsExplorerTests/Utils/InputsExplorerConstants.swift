//
//  InputsExplorerConstants.swift
//  NutriScanTests
//
//  Created by Yago Marques on 22/05/23.
//

import Foundation
@testable import NutriScan

struct InputsExplorerConstants {
    static func mockedRemoteFoodResults() -> Data {
        try! JSONEncoder().encode(mockedRemoteFoods())
    }

    static func mockedRemoteFoods() -> [RemoteFood] {
        [
            .init(name: "uva", category: "fruta", itens: []),
            .init(name: "batata", category: "vegetal", itens: []),
            .init(name: "banana", category: "fruta", itens: [])
        ]
    }
}

//
//  CoreDataWorkerStub.swift
//  NutriScanTests
//
//  Created by Yago Marques on 22/05/23.
//

import Foundation
@testable import NutriScan

final class CoreDataWorkerStub: FoodCoredataWorker {
    enum Message: Equatable {
        case createFoodsCalled
        case readFoodsCalled
    }

    var foods = [RemoteFood]()
    var receivedMessages = [Message]()

    func createFoods(with remoteModels: [NutriScan.RemoteFood]) throws {
        remoteModels.forEach { foods.append($0) }
        receivedMessages.append(.createFoodsCalled)
    }

    func readFoods() throws -> [NutriScan.RemoteFood] {
        receivedMessages.append(.readFoodsCalled)
        return foods
    }

    func populateCache() {
        foods.append(.init(name: "teste", category: "teste", itens: []))
    }
}

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
    var willFail = false

    func createFoods(with remoteModels: [NutriScan.RemoteFood]) throws {
        if willFail {
            throw CacheError.cacheEmpty
        }

        remoteModels.forEach { foods.append($0) }
        receivedMessages.append(.createFoodsCalled)
    }

    func readFoods() throws -> [NutriScan.RemoteFood] {
        if willFail {
            throw CacheError.cacheEmpty
        }
        
        receivedMessages.append(.readFoodsCalled)
        return foods
    }

    func populateCache() {
        foods.append(.init(name: "teste", category: "teste", itens: []))
    }
}

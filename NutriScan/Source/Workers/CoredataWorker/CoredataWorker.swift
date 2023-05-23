//
//  CoredataWorker.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import Foundation
import CoreData

protocol FoodCoredataWorker {
    func createFoods(with remoteModels: [RemoteFood]) throws
    func readFoods() throws -> [RemoteFood]
//    func reloadFoods(_ foods: [RemoteFood]) throws
}

enum CoreDataError: Error {
    case invalidDecode
}

struct CoredataWorker: FoodCoredataWorker {
    let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer = CoreDataStack.persistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func createFoods(with remoteModels: [RemoteFood]) throws {
        do {
            let context = persistentContainer.viewContext

            for food in remoteModels {
                let data = try JSONEncoder().encode(food)
                let entity = FoodEntity(context: context)

                entity.data = data

                try context.save()
            }
        } catch {
            throw error
        }
    }

    func readFoods() throws -> [RemoteFood] {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<FoodEntity>(entityName: "FoodEntity")

        do {
            let entities = try context.fetch(fetchRequest)
            return try entities.map { entity in
                if let data = entity.data {
                    return try JSONDecoder().decode(RemoteFood.self, from: data)
                } else { throw CoreDataError.invalidDecode }
            }
        } catch let error {
            throw error
        }
    }

    func reloadFoods(_ foods: [RemoteFood]) throws {
        // development
    }
}

//
//  CoredataStack.swift
//  NutriScan
//
//  Created by Yago Marques on 16/05/23.
//

import Foundation
import CoreData

struct CoreDataStack {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NutriScan")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }

        return container
    }()
}

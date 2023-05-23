//
//  MLClassification.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import Foundation

protocol MLFruitAndVegetableClassifier {
    func createClassificationsRequest(for image: Data, completion: @escaping (String) -> Void)
}

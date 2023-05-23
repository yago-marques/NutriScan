//
//  MlWorkerMock.swift
//  NutriScanTests
//
//  Created by Yago Marques on 22/05/23.
//

import Foundation
@testable import NutriScan

final class MlWorkerMock: MLFruitAndVegetableClassifier {
    var createClassificationsRequestWasCalled = false
    var imageData: Data? = nil

    func createClassificationsRequest(for image: Data, completion: @escaping (String) -> Void) {
        createClassificationsRequestWasCalled = true
        imageData = image

        completion("imageClassification")
    }
}

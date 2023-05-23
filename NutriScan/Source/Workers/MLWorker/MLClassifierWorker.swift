//
//  MLWorker.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import UIKit
import Vision

final class MLClassifierWorker: MLFruitAndVegetableClassifier {

    func classificationRequest(completion: @escaping (String) -> Void) -> VNCoreMLRequest {
        do {
            let instance = try FruitsAndVegetables(configuration: MLModelConfiguration())
            let model = try VNCoreMLModel(for: instance.model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error) { classification in
                    completion(classification)
                }
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }

    func processClassifications(for request: VNRequest, error: Error?, completion: @escaping (String) -> Void) {
        DispatchQueue.main.async {
            guard let results = request.results else { return }
            let classifications = results as! [VNClassificationObservation]
            let topClassifications = classifications.prefix(2)
            let descriptions = topClassifications.map { classification in
                return String(format: "(%.2f) %@", classification.confidence, classification.identifier)
            }

            completion(descriptions.first ?? "")
        }
    }

    func createRequest(for image: Data, completion: @escaping (String) -> Void) {
        guard let ciImage = CIImage(data: image)
        else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            do {
                try handler.perform([self.classificationRequest() { completion($0) }])
            }catch {
                print("Failed to perform \n\(error.localizedDescription)")
            }
        }
    }

    func createClassificationsRequest(for image: Data, completion: @escaping (String) -> Void) {
        createRequest(for: image) { classification in
            completion(classification)
        }
    }
}

//
//  FloodImageClassifier.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.03.2026.
//

import CoreML
import Vision
import UIKit

final class FloodImageClassifier {

    static let shared = FloodImageClassifier()

    private let model: VNCoreMLModel

    private init() {
        guard let coreMLModel = try? FloodClassifier(configuration: MLModelConfiguration()).model,
              let vnModel = try? VNCoreMLModel(for: coreMLModel) else {
            fatalError("Failed to load FloodClassifier model")
        }
        self.model = vnModel
    }

    func classify(image: UIImage, completion: @escaping (Bool, Float) -> Void) {

        guard let ciImage = CIImage(image: image) else {
            completion(false, 0)
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let top = results.first else {
                completion(false, 0)
                return
            }

            let isFlood = top.identifier == "flooded"
            let confidence = top.confidence
            completion(isFlood, confidence)
        }

        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}

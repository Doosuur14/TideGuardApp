//
//  FloodImageClassifier.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.03.2026.
//

//import CoreML
//import Vision
//import UIKit
//
//final class FloodImageClassifier {
//
//    static let shared = FloodImageClassifier()
//
//    private let model: VNCoreMLModel
//
//    private init() {
//
//        let config = MLModelConfiguration()
//        config.computeUnits = .cpuOnly
//
//        guard let coreMLModel = try? FloodClassifier(configuration: MLModelConfiguration()).model,
//              let vnModel = try? VNCoreMLModel(for: coreMLModel) else {
//            fatalError("Failed to load FloodClassifier model")
//        }
//        self.model = vnModel
//    }
////
////    func classify(image: UIImage, completion: @escaping (Bool, Float) -> Void) {
////
////        guard let ciImage = CIImage(image: image) else {
////            completion(false, 0)
////            return
////        }
////
////        let request = VNCoreMLRequest(model: model) { request, error in
////            guard let results = request.results as? [VNClassificationObservation],
////                  let top = results.first else {
////                completion(false, 0)
////                return
////            }
////
////            let isFlood = top.identifier == "flooded"
////            let confidence = top.confidence
////            completion(isFlood, confidence)
////        }
////
////        request.imageCropAndScaleOption = .centerCrop
////
////        let handler = VNImageRequestHandler(ciImage: ciImage)
////        DispatchQueue.global(qos: .userInitiated).async {
////            try? handler.perform([request])
////        }
////    }
//
////    func classify(image: UIImage, completion: @escaping (Bool, Float, String) -> Void) {
////        guard let ciImage = CIImage(image: image) else {
////            completion(false, 0, "minor")
////            return
////        }
////
////        let request = VNCoreMLRequest(model: model) { request, error in
////            guard let results = request.results as? [VNClassificationObservation],
////                  let top = results.first else {
////                completion(false, 0, "minor")
////                return
////            }
////
////            let isFlood = top.identifier == "flooded"
////            let confidence = top.confidence
////
////            let severity: String
////            switch confidence {
////            case 0.60..<0.75: severity = "minor"
////            case 0.75..<0.90: severity = "moderate"
////            default:          severity = "severe"
////            }
////
////            completion(isFlood, confidence, severity)
////        }
////
////        request.imageCropAndScaleOption = .centerCrop
////        let handler = VNImageRequestHandler(ciImage: ciImage)
////        DispatchQueue.global(qos: .userInitiated).async {
////            try? handler.perform([request])
////        }
////    }
//
//    func classify(image: UIImage, completion: @escaping (Bool, Float, String) -> Void) {
//        guard let ciImage = CIImage(image: image) else {
//            print("❌ FloodClassifier: Failed to create CIImage")
//            completion(false, 0, "minor")
//            return
//        }
//
//        let request = VNCoreMLRequest(model: model) { request, error in
//            if let error = error {
//                print("❌ FloodClassifier error: \(error)")
//                completion(false, 0, "minor")
//                return
//            }
//
//            guard let results = request.results as? [VNClassificationObservation],
//                  let top = results.first else {
//                print("❌ FloodClassifier: No results")
//                completion(false, 0, "minor")
//                return
//            }
//
//            print("🔍 Top result: \(top.identifier) confidence: \(top.confidence)")
//            print("🔍 All results: \(results.map { "\($0.identifier):\($0.confidence)" })")
//
//            let isFlood = top.identifier == "flooded"
//            let confidence = top.confidence
//
//            let severity: String
//            switch confidence {
//            case 0.60..<0.75: severity = "minor"
//            case 0.75..<0.90: severity = "moderate"
//            default:          severity = "severe"
//            }
//
//            completion(isFlood, confidence, severity)
//        }
//
//        request.imageCropAndScaleOption = .centerCrop
//
//        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
//        DispatchQueue.global(qos: .userInitiated).async {
//            do {
//                try handler.perform([request])
//            } catch {
//                print("❌ FloodClassifier perform error: \(error)")
//                completion(false, 0, "minor")
//            }
//        }
//    }
//}


//import CoreML
//import UIKit
//import Vision
//
//final class FloodImageClassifier {
//
//    static let shared = FloodImageClassifier()
//    private let model: MyFloodImageClassifier
//
//    private init() {
//        let config = MLModelConfiguration()
//        config.computeUnits = .cpuOnly
//
//        do {
//            self.model = try MyFloodImageClassifier(configuration: config)
//            print("✅ FloodClassifier loaded successfully")
//        } catch {
//            fatalError("Failed to load FloodClassifier: \(error)")
//        }
//    }
//
//    func classify(image: UIImage, completion: @escaping (Bool, Float, String) -> Void) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            guard let cgImage = image.cgImage else {
//                print("❌ Failed to get CGImage")
//                DispatchQueue.main.async { completion(false, 0, "minor") }
//                return
//            }
//
//            // Create a Vision request using the CoreML model
//            guard let mlModel = try? VNCoreMLModel(for: self.model.model) else {
//                print("❌ Failed to create VNCoreMLModel")
//                DispatchQueue.main.async { completion(false, 0, "minor") }
//                return
//            }
//
//            let request = VNCoreMLRequest(model: mlModel) { [weak self] request, error in
//                if let error = error {
//                    print("❌ Vision request error: \(error)")
//                    DispatchQueue.main.async { completion(false, 0, "minor") }
//                    return
//                }
//
//                guard let results = request.results as? [VNClassificationObservation] else {
//                    print("❌ No classification results")
//                    DispatchQueue.main.async { completion(false, 0, "minor") }
//                    return
//                }
//
//                // Get all classifications
//                let classificationDict = Dictionary(uniqueKeysWithValues: results.map { ($0.identifier, $0.confidence) })
//                let floodProb = classificationDict["Flood"] ?? 0
//                let nonFloodProb = classificationDict["Non_Flood"] ?? 0
//
//                print("🔍 All probabilities: Flood=\(String(format: "%.2f", floodProb)), Non_Flood=\(String(format: "%.2f", nonFloodProb))")
//
//                let isFlood = floodProb > nonFloodProb
//                let confidence = isFlood ? floodProb : nonFloodProb
//
//                print("🔍 Result: \(isFlood ? "FLOOD" : "NON_FLOOD") | confidence: \(Int(confidence * 100))%")
//
//                let severity: String
//                if isFlood {
//                    switch confidence {
//                    case 0.60..<0.75: severity = "minor"
//                    case 0.75..<0.90: severity = "moderate"
//                    default:          severity = "severe"
//                    }
//                } else {
//                    severity = "minor"
//                }
//
//                DispatchQueue.main.async {
//                    completion(isFlood, Float(confidence), severity)
//                }
//            }
//
//            // Configure request to handle image orientation
//            request.imageCropAndScaleOption = .centerCrop
//
//            // Run the request
//            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//            do {
//                try handler.perform([request])
//            } catch {
//                print("❌ Failed to perform Vision request: \(error)")
//                DispatchQueue.main.async { completion(false, 0, "minor") }
//            }
//        }
//    }
//}




import CoreML
import UIKit
import CoreVideo

final class FloodImageClassifier {

    static let shared = FloodImageClassifier()
    private let model: MyFloodImageClassifier
    private var callCounter = 0

    private init() {
        let config = MLModelConfiguration()
        config.computeUnits = .cpuOnly

        do {
            self.model = try MyFloodImageClassifier(configuration: config)
            print("✅ FloodClassifier loaded successfully")
        } catch {
            fatalError("Failed to load FloodClassifier: \(error)")
        }
    }

    func classify(image: UIImage, completion: @escaping (Bool, Float, String) -> Void) {
        callCounter += 1
        let callID = callCounter

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            print("[\(callID)] 📌 Starting classification...")
            print("[\(callID)] 📌 Original image size: \(image.size)")

            // Fix orientation
            let processedImage = image.fixedOrientation() ?? image
            print("[\(callID)] 📌 After orientation fix: \(processedImage.size)")

            // Resize to 360x360
            let resized = self.resizeImage(processedImage, to: CGSize(width: 360, height: 360))
            print("[\(callID)] 📌 After resize: \(resized.size)")
            print("[\(callID)] 📌 Resized image has cgImage: \(resized.cgImage != nil)")

            // Convert to pixel buffer
            guard let pixelBuffer = self.imageToPixelBuffer(resized) else {
                print("[\(callID)] ❌ Failed to convert image to pixel buffer")
                DispatchQueue.main.async { completion(false, 0, "minor") }
                return
            }

            print("[\(callID)] 📌 Pixel buffer created successfully")
            print("[\(callID)] 📌 Buffer width: \(CVPixelBufferGetWidth(pixelBuffer)), height: \(CVPixelBufferGetHeight(pixelBuffer))")

            do {
                // Run prediction
                let output = try self.model.prediction(image: pixelBuffer)

                // Get the predicted class name
                let predictedClass = output.target

                // Get the probabilities dictionary
                let probabilities = output.targetProbability

                print("[\(callID)] 🔍 Predicted class: \(predictedClass)")
                print("[\(callID)] 🔍 All probabilities: \(probabilities)")

                // Extract flood and non-flood probabilities
                let floodProb = probabilities["Flood"] ?? 0
                let nonFloodProb = probabilities["Non_Flood"] ?? 0

                print("[\(callID)] 🔍 Flood prob: \(String(format: "%.4f", floodProb)), Non_Flood prob: \(String(format: "%.4f", nonFloodProb))")

                // Determine if it's a flood based on which probability is higher
                let isFlood = predictedClass == "Flood"
                let confidence = Float(isFlood ? floodProb : nonFloodProb)

                print("[\(callID)] 🔍 Result: \(isFlood ? "✅ FLOOD" : "❌ NON_FLOOD") | \(Int(confidence * 100))% confidence")

                let severity: String
                if isFlood {
                    switch confidence {
                    case 0.60..<0.75: severity = "minor"
                    case 0.75..<0.90: severity = "moderate"
                    default:          severity = "severe"
                    }
                } else {
                    severity = "minor"
                }

                print("[\(callID)] 📌 Calling completion handler...")
                DispatchQueue.main.async {
                    print("[\(callID)] 📌 Completion handler on main thread")
                    completion(isFlood, confidence, severity)
                }

            } catch {
                print("[\(callID)] ❌ Prediction error: \(error)")
                DispatchQueue.main.async { completion(false, 0, "minor") }
            }
        }
    }

    private func imageToPixelBuffer(_ image: UIImage) -> CVPixelBuffer? {
        guard let cgImage = image.cgImage else {
            print("❌ CGImage is nil!")
            return nil
        }

        print("📌 CGImage width: \(cgImage.width), height: \(cgImage.height)")

        let frameWidth = 299
        let frameHeight = 299

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            frameWidth,
            frameHeight,
            kCVPixelFormatType_32BGRA,
            nil,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            print("❌ CVPixelBufferCreate failed with status: \(status)")
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: frameWidth,
            height: frameHeight,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
        ) else {
            print("❌ CGContext creation failed")
            return nil
        }

        print("📌 CGContext created, drawing image...")
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight))
        print("📌 Image drawn to buffer")

        return buffer
    }

    private func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resized
    }
}

extension UIImage {
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != .up else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

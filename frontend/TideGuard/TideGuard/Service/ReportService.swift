//
//  ReportService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 09.06.2025.
//

import Foundation
import UIKit
import Alamofire

final class ReportService {
    static let shared = ReportService()
    private let baseURL = "http://localhost:8080"

    func uploadReport(
        image: UIImage?,
        description: String,
        email: String,
        latitude: Double,
        longitude: Double,
        severity: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let url = "\(baseURL)/report"

        guard let image = image, let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No image selected"])))
            return
        }

        AF.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "photo", fileName: "report.jpg", mimeType: "image/jpeg")
            formData.append(description.data(using: .utf8)!, withName: "description")
            formData.append("\(latitude)".data(using: .utf8)!, withName: "latitude")
            formData.append("\(longitude)".data(using: .utf8)!, withName: "longitude")
            formData.append(severity.data(using: .utf8)!,       withName: "severity")
        }, to: url, headers: ["email": email])
        .validate()
        .responseDecodable(of: ReportResponse.self) { response in
            switch response.result {
            case .success(let report):
                completion(.success(report.photoUrl ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct ReportResponse: Decodable {
    let id: Int
    let photoUrl: String?
    let description: String?
    let fileName: String?
    let latitude: Double?
    let longitude: Double?
}

//
//  ReportService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 09.06.2025.
//

import Foundation
import UIKit
import Alamofire

class ReportService {
    static let shared = ReportService()
    private let baseURL = "http://localhost:8080"

    func uploadReport(image: UIImage?, description: String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = image, let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No image selected"])))
            return
        }

        let url = "\(baseURL)/report"
        let headers: HTTPHeaders = ["email": email]

        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "photo", fileName: "\(email)_report.jpg", mimeType: "image/jpeg")
                multipartFormData.append(description.data(using: .utf8)!, withName: "description")
            },
            to: url,
            headers: headers
        ).responseDecodable(of: ReportResponse.self) { response in
            switch response.result {
            case .success(let reportResponse):
                completion(.success(reportResponse.photoUrl))
            case .failure(let error):
                print("Error uploading report: \(error)")
                if let statusCode = response.response?.statusCode {
                    print("HTTP Status Code: \(statusCode)")
                }
                completion(.failure(error))
            }
        }
    }
}

struct ReportResponse: Decodable {
    let id: Int
    let photoUrl: String
    let description: String
    let fileName: String
}

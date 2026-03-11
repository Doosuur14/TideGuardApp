//
//  FloodForecastService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 12.03.2026.
//

import Foundation
import Alamofire

final class FloodForecastService {

    static let shared = FloodForecastService()
    private let baseURL = "http://localhost:8080"
    private init() {}

    func fetchFloodForecast(for state: String, completion: @escaping (Result<[FloodForecast], Error>) -> Void) {
        guard let encodedState = state.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(.failure(NSError(domain: "", code: -1)))
            return
        }
        let url  = "\(baseURL)/api/flood-forecast/\(encodedState)"
        AF.request(url)
            .validate()
            .responseDecodable(of: [FloodForecast].self) { response in
                switch response.result {
                case .success(let days):
                    completion(.success(days))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

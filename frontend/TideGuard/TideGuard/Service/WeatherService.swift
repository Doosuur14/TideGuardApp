//
//  WeatherService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 28.04.2025.
//

import Foundation
import Alamofire

final class WeatherService {
    static let shared = WeatherService()
    private let baseURL = "http://192.168.31.202:8080"

    private init() {}

    func fetchWeather(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {

        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode city"])))
            return
        }
        let url = "\(baseURL)/api/weather/\(encodedCity)"
        AF.request(url)
            .validate()
            .responseDecodable(of: WeatherData.self) { response in
                switch response.result {
                case .success(let weatherData):
                    completion(.success(weatherData))
                case .failure(let error):
                    print("Failed to fetch weather: \(error)")
                    completion(.failure(error))
                }
            }
    }
}

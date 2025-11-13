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
    private let baseURL = "http://localhost:8080"

    private init() {}

    func fetchEvacuationData(for city: String, completion: @escaping (Result<Evacuation, Error>) -> Void) {
        let url = "\(baseURL)/evacuation/\(city)"
        AF.request(url)
            .validate()
            .responseDecodable(of: Evacuation.self) { response in
                switch response.result {
                case .success(let evacuation):
                    completion(.success(evacuation))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
       }

    func fetchFloodAreas(for city: String, completion: @escaping (Result<FloodArea, Error>) -> Void) {
        let url = "\(baseURL)/api/flood-areas/\(city)"
        AF.request(url)
            .validate()
            .responseDecodable(of: FloodArea.self) { response in
                switch response.result {
                case .success(let floodArea):
                    completion(.success(floodArea))
                case .failure(let error):
                    print("Failed to fetch flood areas: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }

    func fetchFloodRisk(for city: String, completion: @escaping (Result<FloodRiskResponse, Error>) -> Void) {
        let url = "\(baseURL)/api/risk/\(city)"
        AF.request(url)
            .validate()
            .responseDecodable(of: FloodRiskResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }

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

//
//  ShelterService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 30.03.2026.
//

import Foundation

class ShelterService {

    static let shared = ShelterService()

    private let baseURL = "http://localhost:8080/api/shelters"

    private init() {}

    
    func fetchSheltersByState(_ state: String, completion: @escaping (Result<[Shelter], Error>) -> Void) {
        let urlString = "\(baseURL)/\(state)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                   
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                }
                return
            }


            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                }
                return
            }

            do {
                let shelters = try JSONDecoder().decode([Shelter].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(shelters))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }


    func fetchAllShelters(completion: @escaping (Result<[Shelter], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                }
                return
            }

            do {
                let shelters = try JSONDecoder().decode([Shelter].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(shelters))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

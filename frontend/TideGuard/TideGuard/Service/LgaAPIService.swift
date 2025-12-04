//
//  LgaAPIService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.11.2025.
//

import Foundation

class LgaAPIService {

    static let shared = LgaAPIService()
    private let baseURL =  "http://192.168.31.202:8080"


    func getLgasByState( for state: String, completion: @escaping ([LgaModel]?) -> Void) {
        let urlString = "\(baseURL)/lgas/\(state)"
        print("BACKEND CALL: Fetching LGAs for state: \(state)")
        print("URL: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("BACKEND ERROR: Invalid URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            print("BACKEND RESPONSE RECEIVED")

            if let error = error {
                print("NETWORK ERROR: \(error.localizedDescription)")
                completion(nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP STATUS: \(httpResponse.statusCode)")
            }

            if let data = data {
                print("RAW DATA RECEIVED: \(data.count) bytes")

                do {
                    let lgas = try JSONDecoder().decode([LgaModel].self, from: data)
                    print("BACKEND SUCCESS: Received \(lgas.count) LGAs")

                   
                    for (index, lga) in lgas.prefix(3).enumerated() {
                        print("   📍 LGA \(index+1): \(lga.lgaName) | Lat: \(lga.latitude) | Long: \(lga.longitude)")
                    }

                    completion(lgas)
                } catch {
                    print("JSON DECODE ERROR: \(error)")
                    completion(nil)
                }
            } else {
                print("BACKEND ERROR: No data received")
                completion(nil)
            }
        }.resume()
    }



    func getAllLgas(completion: @escaping ([LgaModel]?) -> Void) {
        let urlString = "\(baseURL)/lgas/all"
        guard let url = URL(string: urlString) else { completion(nil); return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let lgas = try? JSONDecoder().decode([LgaModel].self, from: data)
                completion(lgas)
            } else {
                completion(nil)
            }
        }.resume()
    }

    func getNigeriaGeoJSON(completion: @escaping (Data?) -> Void) {
        let urlString = "\(baseURL)/lgas/geojson"
        guard let url = URL(string: urlString) else { completion(nil); return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            completion(data)
        }.resume()
    }
}

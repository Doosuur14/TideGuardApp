//
//  NewsService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 11.06.2025.
//

import Foundation
import Alamofire

class NewsService {
    static let shared = NewsService()
    let baseURL = "http://localhost:8080/news"
//    let baseURL = "http://192.168.31.225:8080/news"


    private let session: Session

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120.0
        self.session = Session(configuration: configuration)
    }

    func fetchNews(completion: @escaping (Result<[News], Error>) -> Void) {
        print("Starting network request to \(baseURL)")

        session.request(baseURL)
            .validate()
            .responseDecodable(of: [News].self) { response in
                print("Received response from \(self.baseURL)")
                switch response.result {
                case .success(let news):
                    print("Decoded news: \(news)")
                    completion(.success(news))
                case .failure(let error):
                    print("Network error: \(error)")
                    if let data = response.data, let dataString = String(data: data, encoding: .utf8) {
                        print("Raw response: \(dataString)")
                    }
                    completion(.failure(error))
                }
            }
    }
}

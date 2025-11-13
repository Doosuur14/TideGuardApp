//
//  UserService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 12.05.2025.
//

import Foundation
import Alamofire


final class UserService {

    static let shared = UserService()
    private let baseURL = "http://localhost:8080/api"


    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/delete"
        let headers: HTTPHeaders = ["email": UserDefaults.standard.string(forKey: "userEmail") ?? ""]
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }



    func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "userEmail"), !email.isEmpty else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User email not found"])))
            return
        }
        let url = "\(baseURL)/logout"
        let headers: HTTPHeaders = ["email": email]
        AF.request(url, method: .post, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    UserDefaults.standard.removeObject(forKey: "userEmail")
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }


}

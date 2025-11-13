//
//  ProfileService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 08.05.2025.
//

import Foundation
import UIKit
import CoreData
import Alamofire


final class ProfileService {
    static let shared = ProfileService()

    private let baseURL = "http://localhost:8080/api"

    private var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
    private init() {}

    func loadUserProfile(_ fileName: String, completion: @escaping (UIImage?) -> Void) {
        guard !fileName.isEmpty else {
            completion(nil)
            return
        }

        let sanitizedFileName: String
        if fileName.hasPrefix("http://") || fileName.hasPrefix("https://"), let url = URL(string: fileName) {
            sanitizedFileName = url.lastPathComponent
        } else {
            sanitizedFileName = fileName
        }
        let urlString = "\(baseURL)/files/\(sanitizedFileName)"
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Failed to load profile picture: \(error.localizedDescription)")
                if let statusCode = response.response?.statusCode {
                    print("🗒️ HTTP Status Code: \(statusCode)")
                }
                if let data = response.data, let json = String(data: data, encoding: .utf8) {
                    print("🗒️ Response JSON was: \(json)")
                }
                completion(nil)
            }
        }
    }

    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User email not found"])))
            return
        }
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try context.fetch(fetchRequest)
            guard !users.isEmpty else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
                return
            }
            guard users.count == 1, let userEntity = users.first else {
                if users.count > 1 {
                    print("Warning: Multiple users found for email \(email). Using the first one.")
                }
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data in Core Data"])))
                return
            }
            let id = userEntity.userId
            print("🐛 converted id:", id)

            let url = "\(baseURL)/userProfile/\(id)"
            AF.request(url)
                .validate()
                .responseDecodable(of: AppUser.self) { response in
                    switch response.result {
                    case .success(let appUser):
                        let userProfile = UserProfile(
                            firstName: appUser.firstName ?? "",
                            lastName: appUser.lastName ?? "",
                            email: appUser.email ?? "",
                            city: appUser.city ?? "",
                            profileImageURL: appUser.profileImageURL
                        )
                        completion(.success(userProfile))
                    case .failure(let error):
                        if let code = response.response?.statusCode {
                            print("❌ HTTP \(code) fetching profile for id \(id)")
                        }
                        if let data = response.data, let json = String(data: data, encoding: .utf8) {
                            print("🗒️ Response JSON was:\n", json)
                        }
                        print("⚠️ Alamofire error:", error)
                        completion(.failure(error))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }


    func updateProfile(user: AppUser, profileImage: UIImage?, completion: @escaping (Result<AppUser, Error>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User email not found"])))
            return
        }
        let url = "\(baseURL)/profile" 
        let headers: HTTPHeaders = ["email": email]
        let parameters: [String: String] = [
            "firstName": user.firstName ?? "",
            "lastName": user.lastName ?? "",
            "city": user.city ?? ""
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if let image = profileImage, let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(imageData, withName: "profileImage", fileName: "\(email).png", mimeType: "image/png")
                }
            },
            to: url,
            headers: headers
        ).responseDecodable(of: AppUser.self) { response in
            switch response.result {
            case .success(let updatedUser):
                completion(.success(updatedUser))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    print("❌ HTTP Status Code: \(statusCode)")
                }
                if let data = response.data, let json = String(data: data, encoding: .utf8) {
                    print("🗒️ Response JSON was:\n\(json)")
                }
                completion(.failure(error))
            }
        }
    }

    func fetchFAQs(completion: @escaping (Result<[FAQ], Error>) -> Void) {
        let url = "http://localhost:8080/faqs"
        AF.request(url)
            .validate()
            .responseDecodable(of: [FAQ].self) { response in
                switch response.result {
                case .success(let faqs):
                    completion(.success(faqs))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

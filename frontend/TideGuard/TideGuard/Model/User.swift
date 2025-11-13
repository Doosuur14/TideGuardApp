//
//  User.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.04.2025.
//

import Foundation

struct AppUser: Codable {

    let userId: Int
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
    let city: String?
    let profileImageURL: String?

//    enum CodingKeys: String, CodingKey {
//        case id               = "userId"
//        case firstname        = "firstName"
//        case lastname         = "lastName"
//        case email            = "email"
//        case password         = "password"
//        case city             = "city"
//        case profileImageURL  = "profileImageURL"
//    }
}

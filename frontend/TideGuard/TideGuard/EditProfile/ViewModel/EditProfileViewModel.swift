//
//  EditProfileViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 05.06.2025.
//

import Foundation
import CoreData
import UIKit

class EditProfileViewModel {
    @Published var profile: UserProfile?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var city: String = ""
    @Published var email: String = ""
    private var originalProfileImageURL: String?

    var onProfileDetails: (() -> Void)?
    var onProfileUpdated: (() -> Void)?

    private var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }


    func fetchUserProfile() {
        ProfileService.shared.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userProfile):
                self.profile = UserProfile(firstName: userProfile.firstName, lastName: userProfile.lastName, email: userProfile.email, city: userProfile.city, profileImageURL: userProfile.profileImageURL)
                self.onProfileDetails?()
            case .failure(let error):
                print("Error while fetching user's profile: \(error)")
            }
        }
    }


    func updateUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User email not found"])))
            return
        }
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try context.fetch(fetchRequest)
            guard let userEntity = users.first else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
                return
            }
            let userId = userEntity.userId
            let appUser = AppUser(
                userId: Int(userId),
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: nil,
                city: city,
                profileImageURL: originalProfileImageURL
            )

            ProfileService.shared.updateProfile(user: appUser, profileImage: nil) { [weak self] result in
                switch result {
                case .success(let updatedUser):
                    let updatedProfile = UserProfile(
                        firstName: updatedUser.firstName,
                        lastName: updatedUser.lastName,
                        email: updatedUser.email,
                        city: updatedUser.city,
                        profileImageURL: updatedUser.profileImageURL
                    )
                    self?.profile = updatedProfile
                    completion(.success(updatedProfile))
                case .failure(let error):
                    print("Error updating profile: \(error)")
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

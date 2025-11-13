//
//  ProfileViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 08.05.2025.
//

import Foundation
import UIKit
import CoreData

class ProfileViewModel {
    
    @Published var profile: UserProfile?
    @Published var profileImage: UIImage?
    var onProfileUpdated: (() -> Void)?
    
    private var context: NSManagedObjectContext {
        return CoreDataManager.shared.persistentContainer.viewContext
    }
    
    init() {
        applyTheme()
    }
    
    @objc func toggleTheme() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        UserDefaults.standard.set(!isDarkMode, forKey: "isDarkMode")
        applyTheme()
    }
    
    private func applyTheme() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        let interfaceStyle: UIUserInterfaceStyle = isDarkMode ? .dark : .light
        allWindows().forEach { window in
            window.overrideUserInterfaceStyle = interfaceStyle
        }
        if let appDelegate = UIApplication.shared.delegate as? SceneDelegate,
           let window = appDelegate.window {
            window.overrideUserInterfaceStyle = interfaceStyle
        }
    }
    
    func heightForRowAt() -> Int {
        return 100
    }
    
    
    private func deleteFromCoreData() {
        guard let email =  profile?.email   else { return }
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                context.delete(user)
            }
            try context.save()
            print("User deleted from Core Data")
        } catch {
            print("Failed to delete user from Core Data: \(error)")
        }
    }

    func loadProfilePicture(_ fileName: String) {
        ProfileService.shared.loadUserProfile(fileName) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let image = image {
                    self.profileImage = image
                } else {
                    self.profileImage = UIImage(systemName: "person.circle.fill")
                }
                self.onProfileUpdated?()
            }
        }
    }

    func fetchUserProfile() {
        if let cachedProfile = loadProfileFromCoreData() {
            self.profile = cachedProfile
            if let urlString = cachedProfile.profileImageURL {
                if let fileName = extractFileName(from: urlString) {
                    self.loadProfilePicture(fileName)
                } else {
                    self.onProfileUpdated?()
                }
            } else {
                self.profileImage = UIImage(systemName: "person.circle.fill")
                self.onProfileUpdated?()
            }
        }

        ProfileService.shared.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                let userProfile = UserProfile(
                    firstName: user.firstName,
                    lastName: user.lastName,
                    email: user.email,
                    city: user.city,
                    profileImageURL: user.profileImageURL
                )
                self.profile = userProfile
                self.syncCoreData(user: userProfile)
                if let urlString = userProfile.profileImageURL {
                    self.loadProfilePicture(urlString)
                } else {
                    self.profileImage = UIImage(systemName: "person.circle.fill")
                    self.onProfileUpdated?()
                }
            case .failure(_):
                self.onProfileUpdated?()
            }
        }
    }

    private func loadProfileFromCoreData() -> UserProfile? {
        guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
            return nil
        }
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try context.fetch(fetchRequest)
            guard let userEntity = users.first else {
                return nil
            }
            return UserProfile(
                firstName: userEntity.firstName,
                lastName: userEntity.lastName,
                email: userEntity.email,
                password: nil,
                city: userEntity.city,
                profileImageURL: userEntity.userProfileUrl
            )
        } catch {
            return nil
        }
    }


    private func syncCoreData(user: UserProfile) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", user.email ?? "")
        do {
            let users = try context.fetch(fetchRequest)
            if let userEntity = users.first {
                userEntity.firstName = user.firstName
                userEntity.lastName = user.lastName
                userEntity.city = user.city
                userEntity.userProfileUrl = user.profileImageURL
            } else {
                let newUser = User(context: context)
                newUser.email = user.email
                newUser.firstName = user.firstName
                newUser.lastName = user.lastName
                newUser.city = user.city
                newUser.userProfileUrl = user.profileImageURL
            }
            try context.save()
        } catch {
            print("Core Data sync failed: \(error)")
        }
    }

    private func extractFileName(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let fileName = url.lastPathComponent
        return fileName.isEmpty ? nil : fileName
    }


    func uploadProfilePhoto(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let profile = profile else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])))
            return
        }
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", profile.email ?? "")
        do {
            let users = try context.fetch(fetchRequest)
            guard let userEntity = users.first else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found in Core Data"])))
                return
            }

            let id = userEntity.userId

            let appUser = AppUser(
                userId: Int(id),
                firstName: profile.firstName,
                lastName: profile.lastName,
                email: profile.email, password: "",
                city: profile.city,
                profileImageURL: profile.profileImageURL
            )
            print(appUser)
            ProfileService.shared.updateProfile(user: appUser, profileImage: image) { [weak self] result in
                switch result {
                case .success(let updatedUser):
                    guard let self = self else { return }
                    self.profile = UserProfile(
                        firstName: updatedUser.firstName,
                        lastName: updatedUser.lastName,
                        email: updatedUser.email,
                        city: updatedUser.city,
                        profileImageURL: updatedUser.profileImageURL
                    )
                    self.syncCoreData(user: self.profile!)
                    completion(.success(updatedUser.profileImageURL ?? ""))
                    if let urlString = updatedUser.profileImageURL {
                        self.loadProfilePicture(urlString)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }


    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.profileReuseIdentifier, for: indexPath) as? ProfileTableViewCell
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell?.configureCell(with: Profile(photo: UIImage(systemName: "person.fill"), label: "Edit profile"))
            cell?.redirectButton.setImage(UIImage(systemName: "arrow.forward"), for: .normal)

        case (1, 0):
            let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
            let modeLabel = isDarkMode ? "Dark Mode" : "Light Mode"

            cell?.configureCell(with: Profile(photo: UIImage(systemName: "rays"), label: modeLabel))
            cell?.redirectButton.setImage(UIImage(systemName: "switch.2"), for: .normal)
            cell?.redirectButton.addTarget(self, action: #selector(toggleTheme), for: .touchUpInside)
            cell?.redirectButton.isEnabled = true
            cell?.isUserInteractionEnabled = true
        case (2, 0):
            cell?.configureCell(with: Profile(photo: UIImage(systemName: "questionmark.circle.fill"), label: "FAQ"))
        case (2, 1):
            cell?.configureCell(with: Profile(photo: UIImage(systemName: "phone.fill"), label: "Contact Us"))
        case (3, 0):
            cell?.configureCell(with: Profile(photo: UIImage(systemName: "rectangle.portrait.and.arrow.right"), label: "Log Out"))
        case (3, 1):
            cell?.configureCell(with: Profile(photo: UIImage(systemName: "trash.fill"), label: "Delete Account"))
        default:
            cell?.configureCell(with: Profile(photo: nil, label: ""))
        }
        return cell ?? ProfileTableViewCell(style: .default, reuseIdentifier: ProfileTableViewCell.profileReuseIdentifier)
    }


    func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        UserDefaults.standard.set(nil, forKey: "userEmail")
        UserService.shared.deleteAccount { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.deleteFromCoreData()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
        UserService.shared.logOut { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func allWindows() -> [UIWindow] {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
        } else {
            return UIApplication.shared.windows
        }
    }

}

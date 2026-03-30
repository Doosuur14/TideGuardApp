//
//  ShelterViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 30.03.2026.
//

import Foundation
import CoreData

class SheltersViewModel {

    private let shelterService = ShelterService.shared
    private let context: NSManagedObjectContext

    var shelters: [Shelter] = []
    var isLoading: Bool = false
    var errorMessage: String?


    var onSheltersUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?


    init(context: NSManagedObjectContext) {
        self.context = context
    }


    private func getUserState() -> String? {
        guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
            print("No current user email found in UserDefaults")
            return nil
        }

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(fetchRequest)
            guard let user = users.first else {
                print("No user found with email: \(email)")
                return nil
            }
            return user.city 
        } catch {
            print("Error fetching user from Core Data: \(error.localizedDescription)")
            return nil
        }
    }

    func loadShelters(showAll: Bool = false) {
        isLoading = true
        onLoadingStateChanged?(true)
        errorMessage = nil

        if showAll {
            loadAllShelters()
        } else {
            loadSheltersByUserState()
        }
    }

    private func loadSheltersByUserState() {
        guard let userState = getUserState(), !userState.isEmpty else {
            handleError("Unable to determine your state. Please check your profile.")
            return
        }

        shelterService.fetchSheltersByState(userState) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false
            self.onLoadingStateChanged?(false)

            switch result {
            case .success(let fetchedShelters):
                self.shelters = fetchedShelters
                self.onSheltersUpdated?()

                if fetchedShelters.isEmpty {
                    self.handleError("No shelters found in \(userState). Showing all shelters.")
                    self.loadAllShelters()
                }

            case .failure(let error):
                self.handleError("Failed to load shelters: \(error.localizedDescription)")
            }
        }
    }

    private func loadAllShelters() {
        shelterService.fetchAllShelters { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false
            self.onLoadingStateChanged?(false)

            switch result {
            case .success(let fetchedShelters):
                self.shelters = fetchedShelters
                self.onSheltersUpdated?()

            case .failure(let error):
                self.handleError("Failed to load shelters: \(error.localizedDescription)")
            }
        }
    }


    private func handleError(_ message: String) {
        errorMessage = message
        onError?(message)
    }

    func numberOfShelters() -> Int {
        return shelters.count
    }

    func shelter(at index: Int) -> Shelter? {
        guard index >= 0 && index < shelters.count else { return nil }
        return shelters[index]
    }
}


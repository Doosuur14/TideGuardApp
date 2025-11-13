//
//  CoreDataManager.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.04.2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TideGuardModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Checking if the user already exists in core dat.

    func checkUserExistsInCoreData(email: String, completion: @escaping (Bool) -> Void) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.fetchLimit = 1


        persistentContainer.performBackgroundTask { context in
            do {
                let count = try context.count(for: fetchRequest)
                DispatchQueue.main.async {
                    completion(count > 0)
                }
            } catch {
                print("Error checking user existence: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}

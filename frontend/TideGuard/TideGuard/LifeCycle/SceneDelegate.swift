//
//  SceneDelegate.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 26.03.2025.
//

import UIKit
import UserNotifications


class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UNUserNotificationCenter.current().delegate = self 
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else if granted {
                print("Notification permission granted")
            }
        }

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        applyTheme()

        let navigationController = UINavigationController()
        coordinator = AppCoordinator(navigationController: navigationController)
        coordinator?.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func applyTheme() {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // Show alert and play sound when app is active
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

   
}


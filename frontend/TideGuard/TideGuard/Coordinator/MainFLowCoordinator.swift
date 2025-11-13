//
//  MainFLowCoordinator.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import Foundation
import UIKit


protocol MainFlowCoordinatorProtocol: AnyObject {
    func mainFlowSignOutUser()
}

class MainFlowCoordinator: Coordinator {

    var navigationController: UINavigationController
    private var mainFlowCoordinatorOutput: MainFlowCoordinatorProtocol?

    init(navigationController: UINavigationController, mainFlowCoordinatorOutput: MainFlowCoordinatorProtocol) {
        self.navigationController = navigationController
        self.mainFlowCoordinatorOutput = mainFlowCoordinatorOutput
    }

    func start() {
        let mainviewController = SafetyModuleBuilder().buildMain()
        mainviewController.tabBarItem = UITabBarItem(title: "Safety", image: UIImage(systemName: "exclamationmark.triangle.fill"), tag: 0)
        let reportviewController = ReportModuleBuilder().buildReportScreen()
        //reportviewController.tabBarItem = UITabBarItem(title: "Report", image: UIImage(systemName: "square.and.arrow.up.fill"), tag: 1)
        let reportNav = UINavigationController(rootViewController: reportviewController)
        reportNav.tabBarItem = UITabBarItem(title: "Report", image: UIImage(systemName: "square.and.arrow.up.fill"), tag: 1)
        let newsviewController = NewsModuleBuilder().buildNewsScreen()
        newsviewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper.fill"), tag: 2)
        let profileviewController = ProfileModuleBuilder().buildProfile()
        profileviewController.tabBarItem = UITabBarItem(title: "Profile",
                                                        image: UIImage(systemName: "person.circle.fill"), tag: 3)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainviewController,newsviewController, reportNav,profileviewController]
        tabBarController.tabBar.tintColor = UIColor(named: "MainColor")
        tabBarController.tabBar.backgroundColor = .systemGray6
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}

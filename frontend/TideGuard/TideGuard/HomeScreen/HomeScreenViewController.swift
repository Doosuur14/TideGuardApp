//
//  ViewController.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 26.03.2025.
//

import UIKit

final class HomeScreenViewController: UIViewController, HomeViewDelegate {

    var homeScreenView: HomeScreenView?
    var homeDesignScreen: HomeScreenDesignView?


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    private func setUpView() {
        homeScreenView = HomeScreenView(frame: view.bounds)
        view = homeScreenView
        homeScreenView?.secondView.delegate = self
        homeScreenView?.backgroundColor = .systemBackground
    }

    func alreadyRegisteredaction() {

    }

    func getStartedButtonAction() {

    }


}


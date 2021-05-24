//
//  BaseCoordinator.swift
//  Foursquare
//
//  Created by GoKu on 23/05/2021.
//

import UIKit

//MARK:- BaseCoordinator
class BaseCoordinator: Coordinator {
    var childCoordinalors: [Coordinator] = []
    private var navigationController: UINavigationController
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(backDelegate: BackDelegate?) {}
    
    //MARK:- Start Screen
    func navigate(window: UIWindow?) {
        self.navigationController = UINavigationController()
        self.navigationController.isNavigationBarHidden = false
        let coordinator = FourSquareCoordinator(navigationController: self.navigationController)
        self.childCoordinalors.append(coordinator)
        coordinator.start(backDelegate: nil)
        window?.rootViewController?.removeFromParent()
        window?.rootViewController = self.navigationController
        window?.makeKeyAndVisible()
    }
}

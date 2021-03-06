//
//  FourSquareCoordinator.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import UIKit

//MARK:- FourSquare Coordinator which manages Navigations from and to FourSquare Module
class FourSquareCoordinator: Coordinator {
    var childCoordinalors: [Coordinator] = []
    let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(backDelegate: BackDelegate?) {
        let vc = FourSquareViewController.instantiate()
        vc.title = "Nearby By"
        self.navigationController.viewControllers.append(vc)
    }
    
    
    
}

//
//  BaseViewController.swift
//  Foursquare
//
//  Created by GoKu on 23/05/2021.
//

import UIKit

//MARK:- Base View Controller for Common Functions between View Controllers to be set here
class BaseViewController: UIViewController, Storyboarded {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ConfigureUI()
    }

    func ConfigureUI() {
        
    }
}


//
//  UIViewController+Extension.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import UIKit


extension UIViewController {
    
    func addRealTimeButton(Selector: Selector?) {
        let realTimeBtn = UIBarButtonItem(title: "RealTime", style: .plain, target: self, action: Selector)
        realTimeBtn.tag = 10
        realTimeBtn.tintColor = .accentColor
        navigationItem.rightBarButtonItem = realTimeBtn
    }
}

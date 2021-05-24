//
//  UIColor+Extension.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import UIKit

extension UIColor {
    
    class var accentColor: UIColor {
        return UIColor(named: "AccentColor") ?? UIColor.systemBlue
    }
    class var seperatorColor: UIColor {
        return UIColor(named: "seperatorColor") ?? UIColor.lightGray
    }
}

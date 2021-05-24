//
//  UIDouble+Extension.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation

extension Double {
    func round(places: Int) -> Double {
       let multiplier = pow(10, Double(places))
        return Darwin.round(self * multiplier) / multiplier
    }
}

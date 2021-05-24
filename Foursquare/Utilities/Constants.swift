//
//  Constants.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation


enum Constants: String {
    case clientId = "BVVGWI04AYY3ND2MYDESCVG5OUW33AU2X244J1QM0ZT1NFWZ"
    case client_secret = "2GSJYWKDRRPL3BQWCW5DPMO5EX5M1HVFE2I0L1JCSRJ5RGBH"
    case AppleLanguages
    case googleAPIKey
    case environment
    case distance
    
    func getDefaultDistance() -> Double {
        return 100000000
    }
}


enum Environment: String {
    case Default = ""
    case Development = "Dev URL"
    case Production = "Prod URL"
    
    func changeTo() {
        UserDefaults.standard.setValue(self.rawValue, forKey: Constants.environment.rawValue)
        UserDefaults.standard.synchronize()
    }
    func current() -> Environment? {
        return Environment(rawValue: UserDefaults.standard.value(forKey: Constants.environment.rawValue) as! String)
    }
}

enum AppLanguages: String{
    case en, ar
}

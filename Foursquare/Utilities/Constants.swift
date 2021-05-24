//
//  Constants.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation


enum Constants: String {
    case clientId = "WHAM53UPMHAQ1XKKDR4HGHZJWHODYN5HX4NKP4QDJLSWV3NH"
    case client_secret = "ZYGKMVBUWLGO5WWWUKKD0Y0CX2TQ13MUEETBLPEI1IIVFOAJ"
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

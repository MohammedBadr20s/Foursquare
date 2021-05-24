//
//  Constants.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation


enum Constants: String {
    case clientId = "TLGHZJRXL3HJUMA4TBAWMS5MJDQQJFXUAAOAOHO50GL0HUS3"
    case client_secret = "C2RWHUJXFIKNRECPXTYS5GSLQJDWJFOXN4GIAWSFCGEIGQYI"
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
        return Environment(rawValue: UserDefaults.standard.value(forKey: Constants.environment.rawValue) as? String ?? "")
    }
}

enum AppLanguages: String{
    case en, ar
}

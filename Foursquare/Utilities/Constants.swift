//
//  Constants.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation

//MARK:- Constants of the app
enum Constants: String {
    case clientId = "24RJTKS3GXWYLJFAJMTMPUAOBFXFGUXSGFQYJHU1EYKIYA4I"
    case client_secret = "0NVMOZ3RWODVIAVK2CEPEQ4FEKSJS2E50MJ3KODXXEXG3HPI"
    case AppleLanguages
    case googleAPIKey
    case environment
    case distance
    
    func getDefaultDistance() -> Double {
        return 100000000
    }
}

//MARK:- Environment
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
//MARK:- App languages
enum AppLanguages: String{
    case en, ar
}

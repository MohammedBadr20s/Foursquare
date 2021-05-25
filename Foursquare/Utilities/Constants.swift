//
//  Constants.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation

//MARK:- Constants of the app
enum Constants: String {
    case clientId = "CXDNSHAP5FEEZ114RP5AHQOWRHNAAXRRWZOS0ALNQ4OFPBGM"
    case client_secret = "COLVPXMH1P4IS5TWPDS4XMKI103MJRHMIN02DRB2L24IJW0V"
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
    case Development = "https://api.foursquare.com/v2//"
    case Production = "https://api.foursquare.com/v2/"
    
    func changeTo() {
        UserDefaults.standard.setValue(self.rawValue, forKey: Constants.environment.rawValue)
        UserDefaults.standard.synchronize()
    }
    static func current() -> Environment? {
        return Environment(rawValue: UserDefaults.standard.value(forKey: Constants.environment.rawValue) as? String ?? Environment.Production.rawValue)
    }
}
//MARK:- App languages
enum AppLanguages: String{
    case en, ar
}

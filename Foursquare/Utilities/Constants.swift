//
//  Constants.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation

//MARK:- Constants of the app
enum Constants: String {
    case clientId = "CHFH4V0ADISO4KS5TVBQCFRGPG1ISZMJUT4HW00LWERX4WIZ"
    case client_secret = "GOAUFUO4KB24PAOPYBPTCBT3XKHMYBVILG4S5TGDWJHENJ0W"
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

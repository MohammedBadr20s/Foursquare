//
//  ServerPaths.swift
//  Foursquare
//
//  Created by GoKu on 23/05/2021.
//

import Foundation


enum ServerPath: String {
    case baseURL = "https://api.foursquare.com/v2/"
    case getNearbyPlaces = "/explore"
    case getVenuePhotos = "/photos"
    
    func fullUrl(venueId: String = "", clientId: String, clientSecret: String) -> String {
        return "venues/" + "\(venueId)" + self.rawValue + "?" + "client_id=\(clientId)" + "&client_secret=\(clientSecret)" + "&v=20210523"
    }
}

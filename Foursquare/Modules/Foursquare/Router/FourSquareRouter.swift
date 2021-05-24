//
//  FourSquareRouter.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import Alamofire
import RxSwift

//MARK:- FourSquare Router Which Builds the request for FourSquare Module
enum FourSquareRouter: URLRequestBuilder {
    case exploreNearbyPlace(_ lat: Double,_ long: Double,_ radius: Int)
    case getPhotos(_ venueId: String)
    
//    var baseURL: String {
//        return Environment.current()?.rawValue ?? ServerPath.baseURL.rawValue
//    }
    
    var parameters: Parameters? {
        switch self {
        case .exploreNearbyPlace(let lat, let long, let radius):
            return [
                "ll": "\(lat),\(long)",
                "radius": "\(radius)"
            ]
        case .getPhotos:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .exploreNearbyPlace:
            return .get
        case .getPhotos:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .exploreNearbyPlace:
            return ServerPath.getNearbyPlaces.fullUrl(clientId: Constants.clientId.rawValue, clientSecret: Constants.client_secret.rawValue)
        case .getPhotos(let venueId):
            return ServerPath.getVenuePhotos.fullUrl(venueId: venueId, clientId: Constants.clientId.rawValue, clientSecret: Constants.client_secret.rawValue)
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "Content-Type": "application/json",
        ]
    }
}

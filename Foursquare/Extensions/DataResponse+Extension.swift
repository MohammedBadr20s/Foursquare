//
//  DataResponse+Extension.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import Alamofire

extension AFDataResponse {
    
    func interceptResuest(_ url: String, _ params: Parameters?){
        print("==================[URLRequestBuilder]==================\n")
        print("[URLRequestBuilder] ===(\(url))=== \n")
        print("[URLRequestBuilder] parameters =======> \(params ?? [:]) \n")
        print("[URLRequestBuilder] Header =====> \(request?.allHTTPHeaderFields ?? [:]) \n")
        print(response?.url?.absoluteURL ?? "")
        print("[URLRequestBuilder]statusCode =====> \(response?.statusCode ?? 00000) \n")
        print("[URLRequestBuilder] result ======> ", try? result.get())
        print("==================[URLRequestBuilder]==================\n")
    }
}


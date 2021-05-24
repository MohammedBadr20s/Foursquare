//
//  ErrorModel.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation


struct ErrorModel: BaseModel, Error {
    var meta: Meta?
}

//MARK: - Meta
struct Meta: BaseModel, Codable {
    var code: Int?
    var errorType, errorDetail, requestID: String?

    enum CodingKeys: String, CodingKey {
        case code, errorType, errorDetail
        case requestID = "requestId"
    }
}

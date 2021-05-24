//
//  PhotosModel.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation

// MARK: - PhotosModel
struct PhotosModel: BaseModel, Codable {
    var meta: Meta?
    var response: PhotosResponse?
}

// MARK: - PhotosResponse
struct PhotosResponse: Codable {
    var photos: Photos?
}

// MARK: - Item
struct PhotoItem: Codable {
    var id: String?
    var createdAt: Int?
    var fullLink: String?
    var source: Source?
    var itemPrefix: String?
    var suffix: String?
    var width, height: Int?
    var checkin: Checkin?
    var visibility: String?

    enum CodingKeys: String, CodingKey {
        case id, createdAt, source
        case itemPrefix = "prefix"
        case suffix, width, height, checkin, visibility
    }
}

// MARK: - Checkin
struct Checkin: Codable {
    var id: String?
    var createdAt: Int?
    var type: String?
    var timeZoneOffset: Int?
}

// MARK: - Source
struct Source: Codable {
    var name: String?
    var url: String?
}

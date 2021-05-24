//
//  ExploreModel.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation


// MARK: - ExploreModel
struct ExploreModel: BaseModel, Codable {
    var meta: Meta?
    var response: ExploreResponse?
}

// MARK: - ExploreResponse
struct ExploreResponse: Codable {
    var suggestedFilters: SuggestedFilters?
    var headerLocation, headerFullLocation, headerLocationGranularity: String?
    var totalResults: Int?
    var suggestedBounds: SuggestedBounds?
    var groups: [Group]?
}

// MARK: - Group
struct Group: Codable {
    var type, name: String?
    var items: [GroupItem]?
}

// MARK: - GroupItem
struct GroupItem: Codable {
    var reasons: Reasons?
    var venue: Venue?
    var referralID: String?

    enum CodingKeys: String, CodingKey {
        case reasons, venue
        case referralID = "referralId"
    }
}

// MARK: - Reasons
struct Reasons: Codable {
    var count: Int?
    var items: [ReasonsItem]?
}

// MARK: - ReasonsItem
struct ReasonsItem: Codable {
    var summary: String?
    var type: String?
    var reasonName: String?
}

// MARK: - Venue
struct Venue: Codable {
    var id, name: String?
    var location: Location?
    var categories: [Category]?
    var photos: Photos?
    var venuePage: VenuePage?
}

// MARK: - Category
struct Category: Codable {
    var id, name, pluralName, shortName: String?
    var icon: Icon?
    var primary: Bool?
}

// MARK: - Icon
struct Icon: Codable {
    var iconPrefix: String?
    var suffix: String?

    enum CodingKeys: String, CodingKey {
        case iconPrefix = "prefix"
        case suffix
    }
}

// MARK: - Location
struct Location: Codable {
    var address, crossStreet: String?
    var lat, lng: Double?
    var labeledLatLngs: [LabeledLatLng]?
    var distance: Int?
    var cc: String?
    var city: String?
    var state: String?
    var country: String?
    var formattedAddress: [String]?
    var neighborhood, postalCode: String?
}


// MARK: - LabeledLatLng
struct LabeledLatLng: Codable {
    var label: String?
    var lat, lng: Double?
}

// MARK: - Photos
struct Photos: Codable {
    var count: Int?
    var items: [PhotoItem]?
    var dupesRemoved: Int?
}

// MARK: - VenuePage
struct VenuePage: Codable {
    var id: String?
}

// MARK: - SuggestedBounds
struct SuggestedBounds: Codable {
    var ne, sw: Ne?
}

// MARK: - Ne
struct Ne: Codable {
    var lat, lng: Double?
}

// MARK: - SuggestedFilters
struct SuggestedFilters: Codable {
    var header: String?
    var filters: [Filter]?
}

// MARK: - Filter
struct Filter: Codable {
    var name, key: String?
}

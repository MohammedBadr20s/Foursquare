//
//  BaseModel.swift
//  Foursquare
//
//  Created by GoKu on 23/05/2021.
//

import Foundation

//MARK:- Base Model Protocol
protocol BaseModel: Decoderable, Codable {
    func toJSON() -> [String: Any]?
}


//MARK:- Converts data to JSON Function
extension BaseModel {
    func toJSON() -> [String : Any]? {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(self)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            } else {
                debugPrint("[toJSON JSON-Serialization] fails to convert data to json")
                return nil
            }
            
        } catch let error {
            debugPrint("[toJSON Func] \(error)")
            return nil
        }
    }
}

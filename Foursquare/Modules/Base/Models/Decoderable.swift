//
//  Decoderable.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation

protocol Decoderable {
    static func decodeJSON<T: Codable>(_ res: Any, To model: T.Type, format: JSONDecoder.KeyDecodingStrategy) -> Any?
}


extension Decoderable {
    static func decodeJSON<T: Codable>(_ res: Any, To model: T.Type, format: JSONDecoder.KeyDecodingStrategy) -> Any? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = format
        do {
            guard let jsonData = Data.convertToData(res) else {
                debugPrint("[decodeJSON ConvertToData] decodeJSON func fails to convert json to data.")
                return nil
            }
            
            var result: Any?
            
            if let _ = res as? [String: Any] {
                let object = try decoder.decode(T.self, from: jsonData)
                result = object
            } else {
                let list = try decoder.decode([T].self, from: jsonData)
                result = list
            }
            return result
        } catch let error {
            debugPrint("[decodeJSON Func] \(error)")
            return nil
        }
    }
}

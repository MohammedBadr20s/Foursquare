//
//  Data+Extensions.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation

extension Data {
    static func convertToData(_ obj: Any) -> Data? {
        var data: Data?
        if let jsonString = obj as? String {
            let result = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            data = result
        } else if let jsonArrayOfDic = obj as? [[String: AnyObject]] {
            do {
                let result = try JSONSerialization.data(withJSONObject: jsonArrayOfDic, options: .prettyPrinted)
                data = result
            } catch let error {
                debugPrint("[ConvertToData Func] failed to convert to Array of Dictionary\nError \(error)")
                data = nil
            }
        } else if let jsonDictionary = obj as? [String: AnyObject] {
            do {
                let result = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
                data = result
            } catch let error {
                debugPrint("[ConvertToData Func] failed to convert to Dictionary\nError \(error)")
                data = nil
            }
        }
        
        return data
    }
}

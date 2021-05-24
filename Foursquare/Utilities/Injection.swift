//
//  Injection.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import Swinject

class Injection {
    
    private static let baseContainer = Container()
    static let container = baseContainer.synchronize()
    
    private init() {}
    
    
    private static func registerBaseVM() {
        baseContainer.register(BaseViewModel.self) { (_) in
            return BaseViewModel()
        }
    }
    
    private static func registerFourSquareVM() {
        baseContainer.register(FourSquareViewModel.self) { (_) in
            return FourSquareViewModel()
        }
    }
    
    public static func register() {
        registerBaseVM()
        registerFourSquareVM()
    }
}

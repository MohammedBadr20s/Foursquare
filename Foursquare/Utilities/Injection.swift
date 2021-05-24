//
//  Injection.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import Swinject
//MARK:- Injection
class Injection {
    
    private static let baseContainer = Container()
    static let container = baseContainer.synchronize()
    
    private init() {}
    
    //MARK:- Register BaseViewModel
    private static func registerBaseVM() {
        baseContainer.register(BaseViewModel.self) { (_) in
            return BaseViewModel()
        }
    }
    //MARK:- Register FourSquare View Model
    private static func registerFourSquareVM() {
        baseContainer.register(FourSquareViewModel.self) { (_) in
            return FourSquareViewModel()
        }
    }
    //MARK:- Register Dependencies
    public static func register() {
        registerBaseVM()
        registerFourSquareVM()
    }
}

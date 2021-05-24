//
//  BaseViewModel.swift
//  Foursquare
//
//  Created by GoKu on 23/05/2021.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class BaseViewModel {
    
    let disposeBag = DisposeBag()
    
    let failure = PublishSubject<ErrorModel>()
}

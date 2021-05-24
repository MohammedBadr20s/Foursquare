//
//  BaseViewModel.swift
//  Foursquare
//
//  Created by GoKu on 23/05/2021.
//

import Foundation
import RxSwift

//MARK:- ViewModel to abstract subjects
/*
 Input represents any event or interaction from the View. It can be a button pressed or a cell selected.
 Output would be any changes from the ViewModel that the View has to display.
 */
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

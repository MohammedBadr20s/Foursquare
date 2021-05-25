//
//  FourSquareViewModel.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import RxSwift
import RxRelay

//MARK:- FourSquareViewModel
class FourSquareViewModel: BaseViewModel, ViewModelType {
    
    var input: Input
    var output: Output
    //MARK:- Subjects
    private let places = BehaviorSubject<[GroupItem]>(value: [])
    //MARK:- Input & Output Structs
    struct Input {
    }
    
    struct Output {
        let nearbyPlaces: BehaviorSubject<[GroupItem]>
    }
    
    override init() {
        input = Input()
        output = Output(
            nearbyPlaces: places
        )
        
        super.init()
    }
    
    //MARK:- getting Nearby Places to Specific Point (Lat, Long) with Radius
    func getNearbyPlaces(lat: Double, long: Double, radius: Int = 1000) {
        FourSquareRouter.exploreNearbyPlace(lat, long, radius).Request(model: ExploreModel.self).subscribe { (exploreModel: ExploreModel) in
            print("Number of Groups: \(exploreModel.response?.groups?.count ?? 0)")
            if let warning = exploreModel.response?.warning {
                let err =  ErrorModel(meta: Meta(code: 0, errorType: "", errorDetail: warning.text ?? "", requestID: ""))
                self.places.onNext([])
                self.failure.onNext(err)
            }
            if let items = exploreModel.response?.groups?.first?.items {
                self.groupNearbyPlacesPhotos(items: items)
            } else {
                self.places.onNext([])
            }
        } onError: { (error: Error) in
            let err = error as? ErrorModel ?? ErrorModel(meta: Meta(code: 0, errorType: "", errorDetail: error.localizedDescription, requestID: ""))
            self.places.onNext([])
            self.failure.onNext(err)
        } onCompleted: {
            print("[FourSquare Places-FourSquareViewModel]onCompeted")
        } onDisposed: {
            print("[FourSquare Places-FourSquareViewModel]onDisposed")
        }.disposed(by: self.disposeBag)
    }
    
    //MARK:- Group Items and its Photos Requests to return Array of items with their photos once
    func groupNearbyPlacesPhotos(items: [GroupItem]) {
        let requests = items.map { (item: GroupItem) -> Observable<GroupItem> in
            return getVenuePhoto(item: item)
        }
        Observable<GroupItem>.zip(requests).subscribe(onNext: { (items: [GroupItem]) in
            self.places.onNext(items)
        }, onError: { (error) in
            let err = error as? ErrorModel ?? ErrorModel(meta: Meta(code: 0, errorType: "", errorDetail: error.localizedDescription, requestID: ""))
            self.places.onNext([])
            self.failure.onNext(err)
        }).disposed(by: self.disposeBag)
    }
    
    //MARK:- Get Nearby Place Photo
    func getVenuePhoto(item: GroupItem) -> Observable<GroupItem> {
        var place = item
        return Observable.create { (observer) -> Disposable in
            FourSquareRouter.getPhotos(place.venue?.id ?? "").Request(model: PhotosModel.self).throttle(.seconds(2), scheduler: MainScheduler.instance).subscribe { (photoModel: PhotosModel) in
                let photoLink = (photoModel.response?.photos?.items?.first?.itemPrefix ?? "") + "200x200" + (photoModel.response?.photos?.items?.first?.suffix ?? "")
                print("Photo Link is \(photoLink)")
                place.venue?.photos?.items = [PhotoItem(fullLink: photoLink)]
                observer.onNext(place)
            } onError: { (error: Error) in
                observer.onError(error)
            }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

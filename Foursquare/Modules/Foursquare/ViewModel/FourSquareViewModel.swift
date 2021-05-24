//
//  FourSquareViewModel.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import Foundation
import RxSwift
import RxRelay

class FourSquareViewModel: BaseViewModel, ViewModelType {
    
    var input: Input
    var output: Output
    
    private let places = BehaviorSubject<[GroupItem]>(value: [])
    private var itemsWithPhotos = [GroupItem]() {
        didSet {
            self.places.onNext(itemsWithPhotos)
        }
    }
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
    
    func getNearbyPlaces(lat: Double, long: Double, radius: Int = 1000) {
        FourSquareRouter.exploreNearbyPlace(lat, long, radius).Request(model: ExploreModel.self).subscribe { (exploreModel: ExploreModel) in
            print("Number of Groups: \(exploreModel.response?.groups?.count)")
            if let items = exploreModel.response?.groups?.first?.items {
                self.itemsWithPhotos = []
                items.forEach { (item) in
                    var itemWithPhoto = item
                    self.getVenuePhoto(venueId: itemWithPhoto.venue?.id ?? "") { (photoLink: String?) in
                        itemWithPhoto.venue?.photos?.items = [PhotoItem(fullLink: photoLink)]
                        self.itemsWithPhotos.append(itemWithPhoto)
                    }
                }
            }
        } onError: { (error: Error) in
            let err = error as? ErrorModel ?? ErrorModel(meta: Meta(code: 0, errorType: "", errorDetail: error.localizedDescription, requestID: ""))
            self.failure.onNext(err)
        } onCompleted: {
            print("[FourSquare Places-FourSquareViewModel]onCompeted")
        } onDisposed: {
            print("[FourSquare Places-FourSquareViewModel]onDisposed")
        }.disposed(by: self.disposeBag)
    }
    
    func getVenuePhoto(venueId: String, completion: @escaping (_ photoLink: String?) -> Void) {
        FourSquareRouter.getPhotos(venueId).Request(model: PhotosModel.self).delay(.seconds(2), scheduler: MainScheduler.instance).subscribe { (photoModel: PhotosModel) in
            let photoLink = (photoModel.response?.photos?.items?.first?.itemPrefix ?? "") + "200x200" + (photoModel.response?.photos?.items?.first?.suffix ?? "")
            print("Photo Link is \(photoLink)")
            completion(photoLink)
        } onError: { (error: Error) in
            let err = error as? ErrorModel ?? ErrorModel(meta: Meta(code: 0, errorType: "", errorDetail: error.localizedDescription, requestID: ""))
            self.failure.onNext(err)
        } onCompleted: {
            print("[FourSquare Photos-FourSquareViewModel]onCompeted")
        } onDisposed: {
            print("[FourSquare Photos-FourSquareViewModel]onDisposed")
        }.disposed(by: self.disposeBag)

    }
}

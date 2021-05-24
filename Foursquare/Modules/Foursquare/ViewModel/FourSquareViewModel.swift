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
    private var itemsWithPhotos = [GroupItem]() {
        didSet {
            self.places.onNext(itemsWithPhotos)
        }
    }
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
        self.itemsWithPhotos.removeAll()
        FourSquareRouter.exploreNearbyPlace(lat, long, radius).Request(model: ExploreModel.self).subscribe { (exploreModel: ExploreModel) in
            print("Number of Groups: \(exploreModel.response?.groups?.count ?? 0)")
            if let items = exploreModel.response?.groups?.first?.items {
                
                items.forEach { (item) in
                    var itemWithPhoto = item
                    
                    self.getVenuePhoto(venueId: itemWithPhoto.venue?.id ?? "") { (photoLink: String?, error: ErrorModel?) in
                        if let photo = photoLink {
                            itemWithPhoto.venue?.photos?.items = [PhotoItem(fullLink: photo)]
                            self.itemsWithPhotos.append(itemWithPhoto)
                        }  
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
    
    //MARK:- Getting Venue Photo and while making sure that no two elements are emitted in less than dueTime.
    func getVenuePhoto(venueId: String, completion: @escaping (_ photoLink: String?,_ error: ErrorModel?) -> Void) {
        FourSquareRouter.getPhotos(venueId).Request(model: PhotosModel.self).throttle(.seconds(2), scheduler: MainScheduler.instance).subscribe { (photoModel: PhotosModel) in
            let photoLink = (photoModel.response?.photos?.items?.first?.itemPrefix ?? "") + "200x200" + (photoModel.response?.photos?.items?.first?.suffix ?? "")
            print("Photo Link is \(photoLink)")
            completion(photoLink, nil)
        } onError: { (error: Error) in
            let err = error as? ErrorModel ?? ErrorModel(meta: Meta(code: 0, errorType: "", errorDetail: error.localizedDescription, requestID: ""))
            completion(nil, err)
            self.failure.onNext(err)
        } onCompleted: {
            print("[FourSquare Photos-FourSquareViewModel]onCompeted")
        } onDisposed: {
            print("[FourSquare Photos-FourSquareViewModel]onDisposed")
        }.disposed(by: self.disposeBag)

    }
}

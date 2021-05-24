//
//  FoursquareTests.swift
//  FoursquareTests
//
//  Created by GoKu on 23/05/2021.
//

import XCTest
import RxBlocking
import RxSwift

@testable import Foursquare

class FoursquareTests: XCTestCase {

    let viewModel = Injection.container.resolve(FourSquareViewModel.self)!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetNearbyPlaces() {
        let expectation = self.expectation(description: "Get Nearby Places Parse Expectation")
        do {
            let result = try FourSquareRouter.exploreNearbyPlace(37.33233141, -122.0312186, 1000).Request(model: ExploreModel.self).toBlocking().first()
            if let items = result?.response?.groups?.first?.items {
                XCTAssertTrue(items.count > 0)
                expectation.fulfill()
            }
        } catch let error {
            let err = error as? ErrorModel ?? ErrorModel(meta: Meta(code: 0, errorType: "", errorDetail: error.localizedDescription, requestID: ""))
            XCTFail(err.meta?.errorDetail ?? "")
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetVenuePhoto() {
        let expectation = self.expectation(description: "Get Venue Photos Parse Expectation")
        do {
            let result = try FourSquareRouter.getPhotos("4b0da1acf964a520b94c23e3").Request(model: PhotosModel.self).throttle(.seconds(2), scheduler: MainScheduler.instance).toBlocking().first()
            let photoLink = (result?.response?.photos?.items?.first?.itemPrefix ?? "") + "200x200" + (result?.response?.photos?.items?.first?.suffix ?? "")
            print("Photo Link is \(photoLink)")
            XCTAssertTrue(result?.response?.photos?.items != nil)
            expectation.fulfill()
        } catch let error {
            let err = error as? ErrorModel ?? ErrorModel(meta: Meta(code: 0, errorType: "", errorDetail: error.localizedDescription, requestID: ""))
            XCTFail(err.meta?.errorDetail ?? "")
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFailure() {
        viewModel.failure.bind { (error: ErrorModel) in
            if let errMsg = error.meta?.errorDetail {
                XCTFail(errMsg)
            } else {
                XCTAssertNil(error, "There's no Error found")
            }
            
        }.disposed(by: self.viewModel.disposeBag)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            self.testGetVenuePhoto()
            self.testGetNearbyPlaces()
            self.testFailure()
        }
    }

}

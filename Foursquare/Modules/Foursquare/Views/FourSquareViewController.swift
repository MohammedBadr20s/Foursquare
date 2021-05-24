//
//  FourSquareViewController.swift
//  Foursquare
//
//  Created by GoKu on 24/05/2021.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation
class FourSquareViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let viewModel = FourSquareViewModel()
    var locationManager: LocationManager?
    var isRealTime = false
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            self.viewModel.getNearbyPlaces(lat: currentLocation?.latitude ?? 0, long: currentLocation?.longitude ?? 0, radius: 1000)

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func ConfigureUI() {
        
        self.addRealTimeButton(Selector: #selector(realTimeAction))
        setupTableView()
        self.locationManager = LocationManager(locationManager: CLLocationManager(), coreLocationDelegate: self, viewController: self)
        
    }

    @objc func realTimeAction() {
        if let item =  self.navigationItem.rightBarButtonItem {
            if item.title == "RealTime" {
                item.title = "Single Update"
                isRealTime = true
                self.locationManager?.manager.startUpdatingLocation()
            } else {
                item.title = "RealTime"
                isRealTime = false
                self.locationManager?.manager.requestLocation()
            }
        }
    }
    
    func setupTableView() {
        self.tableView.register(NearbyPlaceCell.NearbyPlaceNib(), forCellReuseIdentifier: NearbyPlaceCell.id)
        self.viewModel.output.nearbyPlaces.observe(on: MainScheduler.instance).bind(to: self.tableView.rx.items) { [weak self] (tableView, row, element) -> UITableViewCell in
            guard let self = self else { return NearbyPlaceCell()}
            
            return self.configureNearbyPlacesCell(tableView: tableView, indexPath: IndexPath(row: row, section: 0), element: element)
        }.disposed(by: self.viewModel.disposeBag)
        
        self.tableView.rx.itemSelected.bind { (indexPath: IndexPath) in
            let places = try? self.viewModel.output.nearbyPlaces.value()
            print("Selected Place Title: \(places?[indexPath.row].venue?.name ?? "")")
        }.disposed(by: self.viewModel.disposeBag)
    }
    
    
    func configureNearbyPlacesCell(tableView: UITableView, indexPath: IndexPath, element: GroupItem) -> NearbyPlaceCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NearbyPlaceCell.id, for: indexPath) as? NearbyPlaceCell else { return NearbyPlaceCell()}
        cell.config(title: element.venue?.name ?? "", descriptionData: element.venue?.location?.formattedAddress?.joined(separator: " - ") ?? "")
        cell.getPhoto(imageURL: element.venue?.photos?.items?.first?.fullLink)
//        self.viewModel.getVenuePhoto(venueId: element.venue?.id ?? "") { (photoLink: String?) in
//            guard let link = photoLink else { return }
//
//            
//        }
        return cell
    }
}


extension FourSquareViewController: CLLocationManagerDelegate {
    //Native Delegate Function whenever
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationManager?.checkLocationAuthorization(manager: manager, viewController: self)
    }
    
    //Native Delegate Function whenever a fail happens during getting location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        self.showToast(message: "Failed to get user's location: \(error.localizedDescription)", status: .info, position: .bottom)
    }
    
    /*Native Delegate Function of CLLocation Manager whenever LocationRequest or
     StartLocationUpdates() Function is running this function gets the latest location
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        //This Condition to get the first location it fetches once the maps loaded which means your current Location
        if self.currentLocation == nil {
            self.currentLocation = location.coordinate
        }
        guard let currentLocation = self.currentLocation else { return }
        if isRealTime == true {
            let lastLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let currentLocationUpdate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let distanceInMeters = Double(currentLocationUpdate.distance(from: lastLocation)).round(places: 2)
            if distanceInMeters > 500 {
                self.currentLocation = location.coordinate
            }
            
        } else {
            self.locationManager?.manager.stopUpdatingLocation()
        }
        
    }
}
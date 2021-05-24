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
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    let viewModel = Injection.container.resolve(FourSquareViewModel.self)!
    var locationManager: LocationManager?
    var isRealTime = false
    //Get Nearby Places with every update on current location depending on RealmTime State
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            self.viewModel.getNearbyPlaces(lat: currentLocation?.latitude ?? 0, long: currentLocation?.longitude ?? 0, radius: 1000)
            self.tableView.showStateView(show: true, state: .loading, msg: "Loading...")

        }
    }
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func ConfigureUI() {
        
        self.addRealTimeButton(Selector: #selector(realTimeAction))
        setupTableView()
        self.locationManager = LocationManager(locationManager: CLLocationManager(), coreLocationDelegate: self, viewController: self)
        bindingViewModel()
    }
    //MARK:- Realtime Action
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
    
    //MARK:- Data binding from ViewModel to View
    func bindingViewModel() {
        self.viewModel.output.nearbyPlaces.bind { (items: [GroupItem]) in
            
            if items.count == 0 {
                self.tableView.showStateView(show: true, state: .noData, msg: "No data found !!")
            } else {
                self.tableView.showStateView(show: false)
            }
        }.disposed(by: self.viewModel.disposeBag)
        self.viewModel.failure.bind { (error: ErrorModel) in
            self.tableView.showStateView(show: true, state: .error, msg: "Something went wrong !! \n\(error.meta?.errorDetail ?? "")")
        }.disposed(by: self.viewModel.disposeBag)
    }
    
    //MARK:- Binding Data to TableView
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
    
    //MARK:- Configure NearbyPlaces Cell
    func configureNearbyPlacesCell(tableView: UITableView, indexPath: IndexPath, element: GroupItem) -> NearbyPlaceCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NearbyPlaceCell.id, for: indexPath) as? NearbyPlaceCell else { return NearbyPlaceCell()}
        cell.config(title: element.venue?.name ?? "", descriptionData: element.venue?.location?.formattedAddress?.joined(separator: " - ") ?? "")
        cell.getPhoto(imageURL: element.venue?.photos?.items?.first?.fullLink)
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
            print("Current Distance between lastUpdate &  CurrentLocation = \(distanceInMeters)")
            if distanceInMeters >= 500 {
                self.currentLocation = location.coordinate
            }
            
        } else {
            self.locationManager?.manager.stopUpdatingLocation()
        }
        
    }
}

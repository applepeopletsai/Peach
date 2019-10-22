//
//  LocationManager.swift
//  Peach
//
//  Created by dean on 2019/8/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol LocationManagerDelegate {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

class LocationManager: NSObject {
    //Singleton
    static let shared = LocationManager()
    
    var locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    var delegate: LocationManagerDelegate?
    var timer = Timer()
    let updateLocationTimeInterval:TimeInterval = 5//間隔多久取得一次user位置
    var locationSharing = false
    
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.delegate = self
    }
    
    // 首次使用 向使用者詢問定位自身位置權限
    func checkLocationPermision() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                DispatchQueue.main.async {
                    self.locationManager.requestWhenInUseAuthorization()//.request...always, .requestLocation
                }
                
            case .restricted, .denied:
                UIApplication.shared.showDefaultUserPermissionAlert(title: "permission_LocationTitle".localized, content: "permission_LocationContent".localized, actionTitle: "permission_LocationGoToSetting".localized)
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            @unknown default:
                print("NOO checkLocationPermission")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    func openLocationUpdate() {
        locationManager.startUpdatingLocation()
        locationSharing = true
        timer = Timer.scheduledTimer(timeInterval: updateLocationTimeInterval, target: self, selector: #selector(startUpdatingLocation), userInfo: nil, repeats: true)
    }
    
    // MARK: update Location
    @objc func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    // Private function
    private func updateLocation(currentLocation: CLLocation) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        guard let delegate = self.delegate else {
            return
        }
        delegate.tracingLocationDidFailWithError(error: error)
    }
}
extension LocationManager : CLLocationManagerDelegate {
    // CLLocationManagerDelegate
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        lastLocation = location
        stopUpdatingLocation()
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        // do on error
        updateLocationDidFailWithError(error: error as NSError)
    }
}

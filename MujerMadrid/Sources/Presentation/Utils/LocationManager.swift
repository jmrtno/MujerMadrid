//
//  LocationManager.swift
//  MujerMadrid
//
//  Created by Javier Martin on 4/8/25.
//

import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var locationHandler: ((CLLocationCoordinate2D?) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation(_ completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        locationHandler = completion
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationHandler?(locations.first?.coordinate)
        locationHandler = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting user location: \(error)")
        locationHandler?(nil)
        locationHandler = nil
    }
}

//
//  LocationManager.swift
//  TravelBuddy
//
//  Created by Nikola Jankovikj on 16.9.24.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    static let shared = LocationManager()
    @Published var city = ""
    @Published var country = ""
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            print("Location not determined")
        case .restricted:
            print("Location restricted")
        case .denied:
            print("Location denied")
        case .authorizedAlways:
            print("Location authorized always")
        case .authorizedWhenInUse:
            print("Location authorized when in use")
        @unknown default:
            print("Location status unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did update locations with \(locations)")
        guard let location = locations.last else { return }
        self.userLocation = location
        reverseGeocode()
    }
    
    func reverseGeocode() {
        if let userLocation {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { [weak self] (placemarks, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error during geocoding: \(error.localizedDescription)")
                    return
                }

                if let placemark = placemarks?.first {
                    self.city = placemark.locality ?? "Unknown city"
                    self.country = placemark.country ?? "Unknown country"
                }
            }
            
        } else {
            print("eeeete kaj pagja")
        }
    }
}

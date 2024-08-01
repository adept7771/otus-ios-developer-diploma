//
//  LocationManager.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getPlace(for: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    private func getPlace(for location: CLLocation) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en_US") // Устанавливаем язык на английский
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            if let error = error {
                print("Failed to reverse geocode location: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                return
            }
            if let city = placemark.locality, let country = placemark.country {
                let locationName = "\(city), \(country)"
                self.delegate?.didUpdateLocationName(locationName)
            } else {
                print("No location details found")
            }
        }
    }
}

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocationName(_ locationName: String)
}


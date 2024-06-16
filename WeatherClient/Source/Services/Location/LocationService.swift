//
//  LocationService.swift
//  WeatherClient
//
//  Created by rendi on 26.05.2024.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func locationService(_ service: LocationService, didUpdateLocation cityName: String)
    func locationService(_ service: LocationService, didFailWithError error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchCurrentCity() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            delegate?.locationService(self, didFailWithError: LocationError.noLocation)
            return
        }
        
        // Use reverse geocoding to get the city name
        let geocoder = CLGeocoder()
        let preferredLocale = Locale(identifier: "en") // Specify English language
        geocoder.reverseGeocodeLocation(location, preferredLocale: preferredLocale) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                self.delegate?.locationService(self, didFailWithError: error)
            } else if let placemark = placemarks?.first {
                if let cityName = placemark.locality {
                    self.delegate?.locationService(self, didUpdateLocation: cityName)
                } else {
                    self.delegate?.locationService(self, didFailWithError: LocationError.noCityName)
                }
            } else {
                self.delegate?.locationService(self, didFailWithError: LocationError.noPlacemark)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationService(self, didFailWithError: error)
    }
}

enum LocationError: Error {
    case noLocation
    case noCityName
    case noPlacemark
}


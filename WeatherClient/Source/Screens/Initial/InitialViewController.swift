//
//  InitialViewController.swift
//  WeatherClient
//
//  Created by rendi on 26.05.2024.
//

import UIKit
import CoreLocation

class InitialViewController: UIViewController {

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure location manager
        locationManager.delegate = self
        checkLocationPermission()
    }
}

private extension InitialViewController {
    private func navigateToMainScreen() {
        let mainVC = MainViewController()
        navigationController?.setViewControllers([mainVC], animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension InitialViewController: CLLocationManagerDelegate {
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission()
    }
    
    private func checkLocationPermission() {
        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            handleLocationPermissionDenied()
        case .authorizedAlways, .authorizedWhenInUse:
            navigateToMainScreen()
        @unknown default:
            fatalError("Unknown CLLocationManager authorization status.")
        }
    }

    private func handleLocationPermissionDenied() {
        let alert = UIAlertController(title: "Location Permission Denied",
                                      message: "Please enable location permissions in settings to use this app.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!,
                options: [:],
                completionHandler: nil
            )
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

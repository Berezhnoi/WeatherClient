//
//  ViewController.swift
//  WeatherClient
//
//  Created by rendi on 11.05.2024.
//

import UIKit

class ViewController: UIViewController {
    private let currentWeatherService: CurrentWeatherService = CurrentWeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        currentWeatherService.getCurrentWeather(for: "Graz"){ result in
            switch result {
            case .success(let weather):
                print("Weather data: \(weather)")
            case .failure(let error):
                print("Error fetching current weather: \(error)")
            }
        }
    }
}


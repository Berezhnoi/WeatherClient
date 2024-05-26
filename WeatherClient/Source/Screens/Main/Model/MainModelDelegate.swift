//
//  MainModelDelegate.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import Foundation

protocol MainModelDelegate: AnyObject {
    
    func currentWeatherDidLoad(with data: CDWeatherInfo)
    func forecastDidLoad(forecastMeta: CDForecast,  forecastItems: [CDForecastItem])
}

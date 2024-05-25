//
//  ServiceProvider.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import Foundation

final class ServiceProvider {
    private static let currentWeatherService = CurrentWeatherService()
    private static let forecastService = ForecastService()
    
    private init() {}
    
    static func coreDataWeatherService() -> CoreDataWeather {
        let service = CoreDataService.shared
        return service
    }
    
    static func currentWeatherNetworkService() -> CurrentWeatherService {
        return currentWeatherService;
    }
    
    static func forecastNetworkService() -> ForecastService {
        return forecastService;
    }
}

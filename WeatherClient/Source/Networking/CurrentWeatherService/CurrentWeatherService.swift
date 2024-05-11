//
//  CurrentWeatherService.swift
//  WeatherClient
//
//  Created by rendi on 11.05.2024.
//

import Foundation

class CurrentWeatherService {
    private let apiClient: APIClient = APIClient()
    
    public func getCurrentWeather(for city: String, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> Void) {
        let endpoint: GetCurrentWeatherEndpoint = GetCurrentWeatherEndpoint(city: city)
        apiClient.request(endpoint) { result in
            completion(result)
        }
    }
}

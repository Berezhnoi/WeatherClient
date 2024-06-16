//
//  ForecastService.swift
//  WeatherClient
//
//  Created by rendi on 12.05.2024.
//

import Foundation

class ForecastService {
    private let apiClient: APIClient = APIClient()
    
    public func getForecast(for city: String, completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        let endpoint: GetForecastEndpoint = GetForecastEndpoint(city: city)
        apiClient.request(endpoint) { result in
            completion(result)
        }
    }
}

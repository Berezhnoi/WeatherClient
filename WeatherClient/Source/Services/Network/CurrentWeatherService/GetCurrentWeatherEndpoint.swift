//
//  GetCurrentWeatherEndpoint.swift
//  WeatherClient
//
//  Created by rendi on 11.05.2024.
//

import Foundation

class GetCurrentWeatherEndpoint: APIEndpoint {
    typealias ResponseType = CurrentWeatherResponse
    
    let path: String
    let method = "GET"
    let headers: [String: String]?
    let body: Data?

    init(city: String, lang: String = "en", units: String = "metric") {
        self.path = "/weather?q=\(city)&lang=\(lang)&units=\(units)"
        self.headers = nil
        self.body = nil
    }
}

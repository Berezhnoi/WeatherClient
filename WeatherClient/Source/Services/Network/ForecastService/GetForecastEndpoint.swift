//
//  GetForecastEndpoint.swift
//  WeatherClient
//
//  Created by rendi on 12.05.2024.
//

import Foundation

class GetForecastEndpoint: APIEndpoint {
    typealias ResponseType = ForecastResponse
    
    let path: String
    let method = "GET"
    let headers: [String: String]?
    let body: Data?
    
    init(city: String, lang: String = "en", units: String = "metric") {
        self.path = "/forecast?q=\(city)&lang=\(lang)&units=\(units)"
        self.headers = nil
        self.body = nil
    }
}

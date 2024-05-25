//
//  Forecast.swift
//  WeatherClient
//
//  Created by rendi on 12.05.2024.
//

import Foundation

struct ForecastResponse: Decodable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [ForecastData]
    let city: ForecastCity
}

struct ForecastData: Decodable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dt_txt: String
}

struct ForecastCity: Decodable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

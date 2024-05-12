//
//  CurrentWeather.swift
//  WeatherClient
//
//  Created by rendi on 11.05.2024.
//

import Foundation

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Rain: Decodable {
    let oneHour: Double?
    let threeHours: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
        case threeHours = "3h"
    }
}

struct Clouds: Decodable {
    let all: Int
}

struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct CurrentWeatherResponse: Decodable {
    let id: Int
    let dt: Int
    let cod: Int
    let timezone: Int
    let visibility: Int
    let name: String
    let base: String
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let sys: Sys
}

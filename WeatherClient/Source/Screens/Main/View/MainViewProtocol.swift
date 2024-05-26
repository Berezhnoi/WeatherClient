//
//  MainViewProtocol.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import Foundation

protocol MainViewProtocol {
    
    func setupCurrentWeather(with data: CDWeatherInfo)
    func setupForecast(forecastMeta: CDForecast, forecastItems: [CDForecastItem])
}

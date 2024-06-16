//
//  CoreDataWeather.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
//

import Foundation

protocol CoreDataWeather: CoreDataCurrentWeather, CoreDataForecast {}

extension CoreDataService: CoreDataWeather {}

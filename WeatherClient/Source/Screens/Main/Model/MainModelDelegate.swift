//
//  MainModelDelegate.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import Foundation

protocol MainModelDelegate: AnyObject {
    
    func dataDidLoad(with data: CDWeatherInfo)
}

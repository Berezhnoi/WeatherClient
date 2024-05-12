//
//  MainModel.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import Foundation

class MainModel {
    
    weak var delegate: MainModelDelegate?
    
    private let currentWeatherService: CurrentWeatherService
    private let coreDataWeather: CoreDataWeather
    private let apiRefreshInterval: TimeInterval = 600 // 10 minutes in seconds
      
    init(delegate: MainModelDelegate? = nil) {
        self.delegate = delegate
        self.currentWeatherService = ServiceProvider.currentWeatherNetworkService()
        self.coreDataWeather = ServiceProvider.coreDataWeatherService()
    }
}

// MARK: - MainModel + CoreData + API
private extension MainModel {
    func storeCurrentWeather(weatherInfo: CurrentWeatherResponse) {
        coreDataWeather.insertWetherInfo(with: weatherInfo)
    }
    
    func deleteAll() {
        coreDataWeather.deleteAll()
    }
    
    func fetchWeatherDataFromLocalStorage() -> CDWeatherInfo? {
        return coreDataWeather.fetchAllWeatherInfo().last
    }
    
    func loadCurrentWeather(for city: String, completion: @escaping (Result<CDWeatherInfo, Error>) -> Void) {
        currentWeatherService.getCurrentWeather(for: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    print("Weather data loaded from API for \(city)")
                    self.deleteAll()
                    self.storeCurrentWeather(weatherInfo: weather)
                    if let updatedData = self.fetchWeatherDataFromLocalStorage() {
                        completion(.success(updatedData))
                    } else {
                        completion(.failure("Data not found" as! Error))
                    }
                case .failure(let error):
                    print("Error fetching current weather for \(city): \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    func isDataFresh(_ weatherData: CDWeatherInfo) -> Bool {
        guard let createdAt = weatherData.createdAt else {
            return false // No timestamp available, data is not fresh
        }
        let currentTime = Date().timeIntervalSince1970
        return currentTime - createdAt.timeIntervalSince1970 <= apiRefreshInterval
    }
}

// MARK: - MainModelProtocol
extension MainModel: MainModelProtocol {
    func loadData() {
        let defaultCity = "Graz"
        
        // Define a completion handler to handle the result of loading weather data
        let completionHandler: (Result<CDWeatherInfo, Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let weather):
                // Call delegate with the newly fetched weather data
                self?.delegate?.dataDidLoad(with: weather)
            case .failure(let error):
                // Handle error
                print("Error loading current weather for \(defaultCity): \(error)")
            }
        }
        
        // Check if weather data is available in local storage
        if let weatherData = fetchWeatherDataFromLocalStorage() {
            delegate?.dataDidLoad(with: weatherData)
            print("Set current weather from local storage")
            
            // If the data is not recent enough, retrieve it from the API
            if !isDataFresh(weatherData) {
                DispatchQueue.global(qos: .default).async {
                    self.loadCurrentWeather(for: defaultCity, completion: completionHandler)
                }
            }
        } else {
            // If the data is not available in local storage, retrieve it from the API.
            loadCurrentWeather(for: defaultCity, completion: completionHandler)
        }
    }
}

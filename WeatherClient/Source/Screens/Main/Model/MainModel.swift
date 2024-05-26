//
//  MainModel.swift
//  WeatherClinet2024
//
//  Created by user on 06.05.2024.
//

import Foundation

class MainModel {
    
    weak var delegate: MainModelDelegate?
    
    private let coreDataWeather: CoreDataWeather
    private let currentWeatherService: CurrentWeatherService
    private let forecastService: ForecastService
    private let locationService: LocationService
    
    private let currentWeatherApiRefreshInterval: TimeInterval = 600 // 10 minutes in seconds
    private let forecastApiRefreshInterval: TimeInterval = 3600 // 1 hour in seconds
      
    init(delegate: MainModelDelegate? = nil) {
        self.delegate = delegate
        self.coreDataWeather = ServiceProvider.coreDataWeatherService()
        self.currentWeatherService = ServiceProvider.currentWeatherNetworkService()
        self.forecastService = ServiceProvider.forecastNetworkService()
        
        self.locationService = LocationService()
        self.locationService.delegate = self
    }
    
    private func loadWeather(for cityName: String, isMainCity: Bool) {
        loadCurrentWeather(cityName: cityName, isMainCity: isMainCity)
        loadForecast(cityName: cityName)
    }
}

// MARK: - MainModelProtocol
extension MainModel: MainModelProtocol {
    func loadData() {
        // Check if there's a main city available in Core Data
        if let cityName = coreDataWeather.fetchMainCity()?.cityName {
            // If a main city is available, load its weather
            loadWeather(for: cityName, isMainCity: true)
        } else {
            // If there's no main city in Core Data, try to fetch the first city encountered
            if let firstCityName = coreDataWeather.fetchFirstCity()?.cityName {
                // Load the weather for the first city encountered
                loadWeather(for: firstCityName, isMainCity: false)
            }
            
            // Since there's no main city, attempt to fetch the current location
            // This will trigger the location service to fetch the current city's weather
            self.locationService.fetchCurrentCity()
        }
    }
}

extension MainModel: LocationServiceDelegate {
    func locationService(_ service: LocationService, didUpdateLocation cityName: String) {
        print("Location service fetched city : \(cityName)")
        loadWeather(for: cityName, isMainCity: true)
    }
    
    func locationService(_ service: LocationService, didFailWithError error: Error) {
        print("Location service error: \(error.localizedDescription)")
        loadWeather(for: "Vienna", isMainCity: false)
    }
}

// MARK: - CurrentWeather
private extension MainModel {
    func storeCurrentWeather(weatherInfo: CurrentWeatherResponse, isMainCity: Bool) {
        coreDataWeather.insertWetherInfo(with: weatherInfo, isMainCity: isMainCity)
    }
    
    func fetchWeatherDataFromLocalStorage(cityName: String) -> CDWeatherInfo? {
        return coreDataWeather.fetchCurrentWeather(for: cityName)
    }
    
    func loadCurrentWeatherAPI(
        for cityName: String,
        isMainCity: Bool,
        completion: @escaping (Result<CDWeatherInfo, Error>
        ) -> Void) {
        currentWeatherService.getCurrentWeather(for: cityName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    print("Weather data loaded from API for \(cityName)")
                    self.coreDataWeather.deleteCityCurrentWeather(cityName: cityName)
                    self.storeCurrentWeather(weatherInfo: weather, isMainCity: isMainCity)
                    if let updatedData = self.fetchWeatherDataFromLocalStorage(cityName: cityName) {
                        completion(.success(updatedData))
                    } else {
                        completion(.failure("Data not found" as! Error))
                    }
                case .failure(let error):
                    print("Error fetching current weather for \(cityName): \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    func isCurrentWeatherDataFresh(_ weatherData: CDWeatherInfo) -> Bool {
        guard let createdAt = weatherData.createdAt else {
            return false // No timestamp available, data is not fresh
        }
        let currentTime = Date().timeIntervalSince1970
        return currentTime - createdAt.timeIntervalSince1970 <= currentWeatherApiRefreshInterval
    }
    
    func loadCurrentWeather(cityName: String, isMainCity: Bool) {
        // Define a completion handler to handle the result of loading weather data
        let completionHandler: (Result<CDWeatherInfo, Error>) -> Void = { [weak self] result in
            switch result {
            case .success(let weather):
                // Call delegate with the newly fetched weather data
                self?.delegate?.currentWeatherDidLoad(with: weather)
            case .failure(let error):
                // Handle error
                print("Error loading current weather for \(cityName): \(error)")
            }
        }
        
        // Check if weather data is available in local storage
        if let weatherData = fetchWeatherDataFromLocalStorage(cityName: cityName) {
            delegate?.currentWeatherDidLoad(with: weatherData)
            print("Set current weather from local storage")
            
            // If the data is not recent enough, retrieve it from the API
            if !isCurrentWeatherDataFresh(weatherData) {
                DispatchQueue.global(qos: .default).async {
                    self.loadCurrentWeatherAPI(for: cityName, isMainCity: isMainCity, completion: completionHandler)
                }
            }
        } else {
            // If the data is not available in local storage, retrieve it from the API.
            loadCurrentWeatherAPI(for: cityName, isMainCity: isMainCity, completion: completionHandler)
        }
    }
    
}

// MARK: - Forecast
private extension MainModel {
    func storeForecast(forecast: ForecastResponse) {
        coreDataWeather.insertForecast(with: forecast)
    }
    
    func fetchForecastFromLocalStorage(cityName: String) -> (forecast: CDForecast?, forecastItems: [CDForecastItem])? {
        return coreDataWeather.fetchCityForecast(cityName: cityName)
    }
    
    func loadForecastAPI(
        for cityName: String,
        completion: @escaping (Result<(forecast: CDForecast?, forecastItems: [CDForecastItem]), Error>) -> Void
    ) {
        forecastService.getForecast(for: cityName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecast):
                    print("Forecast data loaded from API for \(cityName)")
                    self.coreDataWeather.deleteCityForecast(cityName: cityName)
                    self.storeForecast(forecast: forecast)
                    if let updatedData = self.fetchForecastFromLocalStorage(cityName: cityName) {
                        completion(.success(updatedData))
                    } else {
                        completion(.failure("Data not found" as! Error))
                    }
                case .failure(let error):
                    print("Error fetching forecast for \(cityName): \(error)")
                    completion(.failure(error))
                }
            }
        }
    }

    func isForecastDataFresh(_ forecastMeta: CDForecast?) -> Bool {
        guard let updatedAt = forecastMeta?.updatedAt else {
            return false // No timestamp available, data is not fresh
        }
        let currentTime = Date().timeIntervalSince1970
        return currentTime - updatedAt.timeIntervalSince1970 <= forecastApiRefreshInterval
    }
    
    func loadForecast(cityName: String) {
        // Define a completion handler to handle the result of loading forecast
        let completionHandler: (Result<(forecast: CDForecast?, forecastItems: [CDForecastItem]), Error>) -> Void = {
            [weak self] result in
            switch result {
            case .success(let data):
                if let forecastMeta = data.forecast {
                    self?.delegate?.forecastDidLoad(forecastMeta: forecastMeta, forecastItems: data.forecastItems)
                }
            case .failure(let error):
                // Handle error
                print("Error loading forecast for \(cityName): \(error)")
            }
        }
        
        // Check if forecast data is available in local storage
        if let (forecastMeta, forecastItems) = fetchForecastFromLocalStorage(cityName: cityName) {
            
            if (forecastMeta != nil) {
                delegate?.forecastDidLoad(forecastMeta: forecastMeta!, forecastItems: forecastItems)
                print("Set current forecast from local storage")
            }
            
            // If the data is not recent enough, retrieve it from the API
            if !isForecastDataFresh(forecastMeta) {
                DispatchQueue.global(qos: .default).async {
                    self.loadForecastAPI(for: cityName, completion: completionHandler)
                }
            }
        } else {
            // If the data is not available in local storage, retrieve it from the API.
            loadForecastAPI(for: cityName, completion: completionHandler)
        }
    }
}

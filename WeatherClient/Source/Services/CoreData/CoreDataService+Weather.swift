//
//  CoreDataService+Weather.swift
//  WeatherClient
//
//  Created by rendi on 11.05.2024.
//

import CoreData

protocol CoreDataWeather {
    
    func insertWetherInfo(with info: CurrentWeatherResponse)
    func fetchAllWeatherInfo() -> [CDWeatherInfo]
    func deleteAll() -> Void
}

// MARK: - CoreDataWeather
extension CoreDataService: CoreDataWeather {
    func insertWetherInfo(with info: CurrentWeatherResponse) {
        
        let weatherInfoEntityDescription = NSEntityDescription.entity(forEntityName: "CDWeatherInfo", in: context)!
        guard let weatherInfoEntity = NSManagedObject(entity: weatherInfoEntityDescription, insertInto: context) as? CDWeatherInfo
        else {
            assertionFailure()
            return
        }
        
        weatherInfoEntity.id = Int32(info.id)
        weatherInfoEntity.cityName = info.name
        weatherInfoEntity.temperature = info.main.temp
        weatherInfoEntity.pressure = Int32(info.main.pressure)
        weatherInfoEntity.humidity = Int32(info.main.humidity)
        weatherInfoEntity.createdAt = Date()
        
        for details in info.weather {
            if let detailsEntity = insertWetherDeatils(with: details) {
                detailsEntity.relationship = weatherInfoEntity
            }
        }
        
        save(context: context)
    }
    
    func fetchAllWeatherInfo() -> [CDWeatherInfo] {
        
        let fetchRequest = CDWeatherInfo.fetchRequest()
        let fetchedResult = fetchDataFromEntity(CDWeatherInfo.self, fetchRequest: fetchRequest)
        
        return fetchedResult
    }
    
    func deleteAll() {
        deleteAll(CDWeatherInfo.self)
    }
}

// MARK: - WeatherDetails
private extension CoreDataService {
    
    func insertWetherDeatils(with details: Weather) -> CDWeatherDetails? {
        
        let weatherDetailsEntityDescription = NSEntityDescription.entity(forEntityName: "CDWeatherDetails", in: context)!
        guard let weatherDetailsEntity = NSManagedObject(entity: weatherDetailsEntityDescription, insertInto: context) as? CDWeatherDetails
        else {
            assertionFailure()
            return nil
        }
        
        weatherDetailsEntity.id = Int32(details.id)
        weatherDetailsEntity.icon = details.icon
        weatherDetailsEntity.mainInfo = details.main
        weatherDetailsEntity.details = details.description
        
        return weatherDetailsEntity
    }
}

//
//  CoreDataService+CurrentWeather.swift
//  WeatherClient
//
//  Created by rendi on 11.05.2024.
//

import CoreData

protocol CoreDataCurrentWeather {
    func insertWetherInfo(with info: CurrentWeatherResponse, isMainCity: Bool)
    func fetchAllWeatherInfo() -> [CDWeatherInfo]
    func fetchMainCity() -> CDWeatherInfo?
    func fetchFirstCity() -> CDWeatherInfo?
    func fetchCurrentWeather(for cityName: String) -> CDWeatherInfo?
    func deleteCityCurrentWeather(cityName: String) -> Void
    func deleteAllCurrentWeatherInfo() -> Void
}

// MARK: - CoreDataCurrentWeather
extension CoreDataService: CoreDataCurrentWeather {
    func insertWetherInfo(with info: CurrentWeatherResponse, isMainCity: Bool) {
        
        let weatherInfoEntityDescription = NSEntityDescription.entity(forEntityName: "CDWeatherInfo", in: context)!
        guard let weatherInfoEntity = NSManagedObject(entity: weatherInfoEntityDescription, insertInto: context) as? CDWeatherInfo
        else {
            assertionFailure()
            return
        }
        
        weatherInfoEntity.id = Int32(info.id)
        weatherInfoEntity.isMainCity = isMainCity
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
    
    func fetchCurrentWeather(for cityName: String) -> CDWeatherInfo? {
        let fetchRequest: NSFetchRequest<CDWeatherInfo> = CDWeatherInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch current weather for \(cityName): \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchMainCity() -> CDWeatherInfo? {
        let fetchRequest: NSFetchRequest<CDWeatherInfo> = CDWeatherInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isMainCity == true")
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch main city: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchFirstCity() -> CDWeatherInfo? {
        let fetchRequest: NSFetchRequest<CDWeatherInfo> = CDWeatherInfo.fetchRequest()
        fetchRequest.fetchLimit = 1 // Limit to fetch only one result
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch first city: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteAllCurrentWeatherInfo() {
        deleteAll(CDWeatherInfo.self)
    }
    
    func deleteCityCurrentWeather(cityName: String) {
        let fetchRequest: NSFetchRequest<CDWeatherInfo> = CDWeatherInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)

        do {
            if let currentWeather = try context.fetch(fetchRequest).first {
                // Delete associated weather details first
                if let weatherDetails = currentWeather.relationship?.allObjects as? [CDWeatherDetails] {
                    weatherDetails.forEach { context.delete($0) }
                }
                // Then delete the current weather entity itself
                context.delete(currentWeather)
                save(context: context)
            }
        } catch {
            print("Failed to delete current weather: \(error.localizedDescription)")
        }
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

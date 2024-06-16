//
//  CoreDataService+Forecast.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
//

import CoreData

protocol CoreDataForecast {
    func insertForecast(with forecast: ForecastResponse)
    func fetchCityForecast(cityName: String) -> (forecast: CDForecast?, forecastItems: [CDForecastItem], hourlyForecastItems: [CDHourlyForecastItem])
    func deleteCityForecast(cityName: String) -> Void
}

// MARK: - CoreDataForecast
extension CoreDataService: CoreDataForecast {
    func insertForecast(with forecast: ForecastResponse) {
        let forecastEntityDescription = NSEntityDescription.entity(forEntityName: "CDForecast", in: context)!
        guard let forecastEntity = NSManagedObject(entity: forecastEntityDescription, insertInto: context) as? CDForecast else {
            assertionFailure("Failed to create CDForecast entity")
            return
        }

        forecastEntity.id = Int32(forecast.city.id)
        forecastEntity.cityName = forecast.city.name
        forecastEntity.updatedAt = Date()

        var minMaxTemperatures: [Date: (min: Double, max: Double)] = [:]
        var weatherConditionsByDate: [Date: [String: Int]] = [:] // weather conditions

        for forecastData in forecast.list {
            let date = Date(timeIntervalSince1970: forecastData.dt).startOfDay()
            let temperature = forecastData.main.temp
            let weatherCondition = forecastData.weather.first?.main ?? "Unknown" // Get the main weather condition

            // Update the weather condition occurrence count for the current date
            if weatherConditionsByDate[date] == nil {
                weatherConditionsByDate[date] = [:]
            }
            weatherConditionsByDate[date]?[weatherCondition, default: 0] += 1
            
            if var existing = minMaxTemperatures[date] {
                existing.min = min(existing.min, temperature)
                existing.max = max(existing.max, temperature)
                minMaxTemperatures[date] = existing
            } else {
                minMaxTemperatures[date] = (min: temperature, max: temperature)
            }
            
            // Insert hourly forecast item
            if let hourlyForecastItem = insertHourlyForecastItem(
                date: Date(timeIntervalSince1970: forecastData.dt),
                temperature: temperature,
                weatherCondition: weatherCondition,
                parent: forecastEntity)
            {
                forecastEntity.addToRelationshipHourlyForecast(hourlyForecastItem)
            }
        }

        let sortedDates = minMaxTemperatures.keys.sorted()

        for date in sortedDates {
            let (minTemp, maxTemp) = minMaxTemperatures[date]!
            let mostFrequentWeather = weatherConditionsByDate[date]?.max { $0.value < $1.value }?.key ?? "Unknown"

            if let forecastItem = insertForecastItem(date: date, minTemp: minTemp, maxTemp: maxTemp, weatherCondition: mostFrequentWeather, parent: forecastEntity) {
                forecastEntity.addToRelationship(forecastItem)
            }
        }

        save(context: context)
    }

    private func insertForecastItem(date: Date, minTemp: Double, maxTemp: Double, weatherCondition: String, parent: CDForecast) -> CDForecastItem? {
        let forecastItemEntityDescription = NSEntityDescription.entity(forEntityName: "CDForecastItem", in: context)!
        guard let forecastItem = NSManagedObject(entity: forecastItemEntityDescription, insertInto: context) as? CDForecastItem else {
            assertionFailure("Failed to create CDForecastItem entity")
            return nil
        }

        forecastItem.date = date
        forecastItem.tempMin = minTemp
        forecastItem.tempMax = maxTemp
        forecastItem.weatherCondition = weatherCondition
        forecastItem.relationship = parent
        return forecastItem
    }
    
    private func insertHourlyForecastItem(date: Date, temperature: Double, weatherCondition: String, parent: CDForecast) -> CDHourlyForecastItem? {
         let hourlyForecastItemDescription = NSEntityDescription.entity(forEntityName: "CDHourlyForecastItem", in: context)!
         guard let hourlyForecastItem = NSManagedObject(entity: hourlyForecastItemDescription, insertInto: context) as? CDHourlyForecastItem else {
             assertionFailure("Failed to create CDHourlyForecastItem entity")
             return nil
         }
         
         hourlyForecastItem.date = date
         hourlyForecastItem.temperature = temperature
         hourlyForecastItem.weatherCondition = weatherCondition
         hourlyForecastItem.relationship = parent
         return hourlyForecastItem
     }
    
    func fetchCityForecast(cityName: String) -> (forecast: CDForecast?, forecastItems: [CDForecastItem], hourlyForecastItems: [CDHourlyForecastItem]) {
        let fetchRequest: NSFetchRequest<CDForecast> = CDForecast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)

        do {
            if let forecast = try context.fetch(fetchRequest).first {
                let forecastItems = (forecast.relationship as? Set<CDForecastItem>) ?? []
                let hourlyForecastItems = (forecast.relationshipHourlyForecast as? Set<CDHourlyForecastItem>) ?? []
                return (forecast, Array(forecastItems), Array(hourlyForecastItems))
            }
        } catch {
            print("Failed to fetch forecast: \(error.localizedDescription)")
        }

        return (nil, [], [])
    }

    func deleteCityForecast(cityName: String) {
        let fetchRequest: NSFetchRequest<CDForecast> = CDForecast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)

        do {
            if let forecast = try context.fetch(fetchRequest).first {
                // Delete associated forecast items first
                if let forecastItems = forecast.relationship?.allObjects as? [CDForecastItem] {
                    forecastItems.forEach { context.delete($0) }
                }
                // Delete associated hourly forecast items
                if let hourlyForecastItems = forecast.relationshipHourlyForecast?.allObjects as? [CDHourlyForecastItem] {
                    hourlyForecastItems.forEach { context.delete($0) }
                }
                // Then delete the forecast entity itself
                context.delete(forecast)
                save(context: context)
            }
        } catch {
            print("Failed to delete forecast: \(error.localizedDescription)")
        }
    }
}

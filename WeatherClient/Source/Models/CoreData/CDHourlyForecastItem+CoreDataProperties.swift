//
//  CDHourlyForecastItem+CoreDataProperties.swift
//  WeatherClient
//
//  Created by rendi on 16.06.2024.
//
//

import Foundation
import CoreData


extension CDHourlyForecastItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDHourlyForecastItem> {
        return NSFetchRequest<CDHourlyForecastItem>(entityName: "CDHourlyForecastItem")
    }

    @NSManaged public var date: Date?
    @NSManaged public var weatherCondition: String?
    @NSManaged public var id: Int32
    @NSManaged public var temperature: Double
    @NSManaged public var relationship: CDForecast?

}

extension CDHourlyForecastItem : Identifiable {

}

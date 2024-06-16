//
//  CDForecastItem+CoreDataProperties.swift
//  WeatherClient
//
//  Created by rendi on 09.06.2024.
//
//

import Foundation
import CoreData


extension CDForecastItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDForecastItem> {
        return NSFetchRequest<CDForecastItem>(entityName: "CDForecastItem")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: Int32
    @NSManaged public var tempMax: Double
    @NSManaged public var tempMin: Double
    @NSManaged public var weatherCondition: String?
    @NSManaged public var relationship: CDForecast?

}

extension CDForecastItem : Identifiable {

}

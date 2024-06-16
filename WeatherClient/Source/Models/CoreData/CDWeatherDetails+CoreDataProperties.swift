//
//  CDWeatherDetails+CoreDataProperties.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
//
//

import Foundation
import CoreData


extension CDWeatherDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWeatherDetails> {
        return NSFetchRequest<CDWeatherDetails>(entityName: "CDWeatherDetails")
    }

    @NSManaged public var details: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: Int32
    @NSManaged public var mainInfo: String?
    @NSManaged public var relationship: CDWeatherInfo?

}

extension CDWeatherDetails : Identifiable {

}

//
//  CDWeatherInfo+CoreDataProperties.swift
//  WeatherClient
//
//  Created by rendi on 12.05.2024.
//
//

import Foundation
import CoreData


extension CDWeatherInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWeatherInfo> {
        return NSFetchRequest<CDWeatherInfo>(entityName: "CDWeatherInfo")
    }

    @NSManaged public var id: Int32
    @NSManaged public var cityName: String?
    @NSManaged public var temperature: Double
    @NSManaged public var pressure: Int32
    @NSManaged public var humidity: Int32
    @NSManaged public var createdAt: Date?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension CDWeatherInfo {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: CDWeatherDetails)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: CDWeatherDetails)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

extension CDWeatherInfo : Identifiable {

}

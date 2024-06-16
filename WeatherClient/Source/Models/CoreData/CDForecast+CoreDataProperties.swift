//
//  CDForecast+CoreDataProperties.swift
//  WeatherClient
//
//  Created by rendi on 16.06.2024.
//
//

import Foundation
import CoreData


extension CDForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDForecast> {
        return NSFetchRequest<CDForecast>(entityName: "CDForecast")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var id: Int32
    @NSManaged public var updatedAt: Date?
    @NSManaged public var relationship: NSSet?
    @NSManaged public var relationshipHourlyForecast: NSSet?

}

// MARK: Generated accessors for relationship
extension CDForecast {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: CDForecastItem)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: CDForecastItem)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

// MARK: Generated accessors for relationshipHourlyForecast
extension CDForecast {

    @objc(addRelationshipHourlyForecastObject:)
    @NSManaged public func addToRelationshipHourlyForecast(_ value: CDHourlyForecastItem)

    @objc(removeRelationshipHourlyForecastObject:)
    @NSManaged public func removeFromRelationshipHourlyForecast(_ value: CDHourlyForecastItem)

    @objc(addRelationshipHourlyForecast:)
    @NSManaged public func addToRelationshipHourlyForecast(_ values: NSSet)

    @objc(removeRelationshipHourlyForecast:)
    @NSManaged public func removeFromRelationshipHourlyForecast(_ values: NSSet)

}

extension CDForecast : Identifiable {

}

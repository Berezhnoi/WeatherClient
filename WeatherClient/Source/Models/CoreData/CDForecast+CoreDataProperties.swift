//
//  CDForecast+CoreDataProperties.swift
//  WeatherClient
//
//  Created by rendi on 25.05.2024.
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

extension CDForecast : Identifiable {

}

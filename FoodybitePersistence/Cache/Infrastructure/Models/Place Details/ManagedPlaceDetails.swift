//
//  ManagedPlaceDetails+CoreDataClass.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//
//

import Foundation
import CoreData

@objc(ManagedPlaceDetails)
public class ManagedPlaceDetails: NSManagedObject {
    @NSManaged public var placeID: String
    @NSManaged public var phoneNumber: String?
    @NSManaged public var name: String
    @NSManaged public var address: String
    @NSManaged public var rating: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var openingHoursDetails: ManagedOpeningHoursDetails?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPlaceDetails> {
        return NSFetchRequest<ManagedPlaceDetails>(entityName: "ManagedPlaceDetails")
    }    
}

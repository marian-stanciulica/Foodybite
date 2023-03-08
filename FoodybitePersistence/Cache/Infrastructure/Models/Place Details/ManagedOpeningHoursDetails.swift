//
//  ManagedOpeningHoursDetails+CoreDataClass.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//
//

import Foundation
import CoreData

@objc(ManagedOpeningHoursDetails)
public class ManagedOpeningHoursDetails: NSManagedObject {
    @NSManaged public var openNow: String?
    @NSManaged public var weekdayText: NSSet?
    @NSManaged public var placeDetails: ManagedPlaceDetails?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedOpeningHoursDetails> {
        return NSFetchRequest<ManagedOpeningHoursDetails>(entityName: "ManagedOpeningHoursDetails")
    }
}

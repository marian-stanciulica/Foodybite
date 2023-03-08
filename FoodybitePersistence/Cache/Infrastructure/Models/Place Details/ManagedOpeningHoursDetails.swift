//
//  ManagedOpeningHoursDetails+CoreDataClass.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//
//

import Foundation
import CoreData
import Domain

@objc(ManagedOpeningHoursDetails)
public class ManagedOpeningHoursDetails: NSManagedObject {
    @NSManaged public var openNow: Bool
    @NSManaged public var weekdayText: NSSet?
    @NSManaged public var placeDetails: ManagedPlaceDetails?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedOpeningHoursDetails> {
        return NSFetchRequest<ManagedOpeningHoursDetails>(entityName: "ManagedOpeningHoursDetails")
    }
    
    public convenience init(_ model: OpeningHoursDetails, for context: NSManagedObjectContext) {
        self.init(context: context)

        openNow = model.openNow
        model.weekdayText.forEach {
            weekdayText?.adding(ManagedWeekdayText($0, for: context))
        }
    }
}

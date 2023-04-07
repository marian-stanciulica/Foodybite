//
//  ManagedWeekdayText+CoreDataClass.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//
//

import Foundation
import CoreData

@objc(ManagedWeekdayText)
public class ManagedWeekdayText: NSManagedObject {
    @NSManaged public var text: String
    @NSManaged public var openingHours: ManagedOpeningHoursDetails?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedWeekdayText> {
        return NSFetchRequest<ManagedWeekdayText>(entityName: "ManagedWeekdayText")
    }

    public convenience init(_ text: String, for context: NSManagedObjectContext) {
        self.init(context: context)

        self.text = text
    }
}

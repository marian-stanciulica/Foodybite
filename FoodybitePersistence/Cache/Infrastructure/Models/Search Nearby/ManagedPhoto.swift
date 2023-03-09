//
//  ManagedPhoto+CoreDataClass.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.03.2023.
//
//

import Foundation
import CoreData

@objc(ManagedPhoto)
public class ManagedPhoto: NSManagedObject {
    @NSManaged public var width: Int16
    @NSManaged public var height: Int16
    @NSManaged public var reference: String?
    @NSManaged public var placeDetails: ManagedPlaceDetails?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPhoto> {
        return NSFetchRequest<ManagedPhoto>(entityName: "ManagedPhoto")
    }
}

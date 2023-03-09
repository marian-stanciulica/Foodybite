//
//  ManagedPhoto+CoreDataClass.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.03.2023.
//
//

import Foundation
import CoreData
import Domain

@objc(ManagedPhoto)
public class ManagedPhoto: NSManagedObject {
    @NSManaged public var width: Int16
    @NSManaged public var height: Int16
    @NSManaged public var reference: String
    @NSManaged public var placeDetails: ManagedPlaceDetails?
    @NSManaged public var nearbyPlace: ManagedNearbyPlace?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedPhoto> {
        return NSFetchRequest<ManagedPhoto>(entityName: "ManagedPhoto")
    }
    
    public convenience init(_ model: Photo, for context: NSManagedObjectContext) {
        self.init(context: context)

        width = Int16(model.width)
        height = Int16(model.height)
        reference = model.photoReference
    }
}

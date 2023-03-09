//
//  ManagedNearbyPlace.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Foundation
import CoreData
import Domain

@objc(ManagedNearbyPlace)
public class ManagedNearbyPlace: NSManagedObject {
    @NSManaged public var placeID: String
    @NSManaged public var placeName: String
    @NSManaged public var isOpen: Bool
    @NSManaged public var rating: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photo: ManagedPhoto?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedNearbyPlace> {
        return NSFetchRequest<ManagedNearbyPlace>(entityName: "ManagedNearbyPlace")
    }
    
    public convenience init(_ model: NearbyPlace, for context: NSManagedObjectContext) {
        self.init(context: context)

        self.placeID = model.placeID
        self.placeName = model.placeName
        self.isOpen = model.isOpen
        self.rating = model.rating
        self.latitude = model.location.latitude
        self.longitude = model.location.longitude
    }
}

//
//  ManagedNearbyRestaurant.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Foundation
import CoreData
import Domain

@objc(ManagedNearbyRestaurant)
public class ManagedNearbyRestaurant: NSManagedObject {
    @NSManaged public var placeID: String
    @NSManaged public var placeName: String
    @NSManaged public var isOpen: Bool
    @NSManaged public var rating: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photo: ManagedPhoto?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedNearbyRestaurant> {
        return NSFetchRequest<ManagedNearbyRestaurant>(entityName: "ManagedNearbyRestaurant")
    }
    
    public convenience init(_ model: NearbyRestaurant, for context: NSManagedObjectContext) {
        self.init(context: context)

        placeID = model.restaurantID
        placeName = model.placeName
        isOpen = model.isOpen
        rating = model.rating
        latitude = model.location.latitude
        longitude = model.location.longitude
        
        if let photo = model.photo {
            self.photo = ManagedPhoto(photo, for: context)
        }
    }
}

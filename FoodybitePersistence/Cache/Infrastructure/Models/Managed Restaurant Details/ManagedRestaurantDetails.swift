//
//  ManagedRestaurantDetails.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//
//

import Foundation
import CoreData
import Domain

@objc(ManagedRestaurantDetails)
public class ManagedRestaurantDetails: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var phoneNumber: String?
    @NSManaged public var name: String
    @NSManaged public var address: String
    @NSManaged public var rating: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var openingHoursDetails: ManagedOpeningHoursDetails?
    @NSManaged public var photos: NSSet

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedRestaurantDetails> {
        return NSFetchRequest<ManagedRestaurantDetails>(entityName: "ManagedRestaurantDetails")
    }

    public convenience init(_ model: RestaurantDetails, for context: NSManagedObjectContext) {
        self.init(context: context)

        id = model.id
        phoneNumber = model.phoneNumber
        name = model.name
        address = model.address
        rating = model.rating
        latitude = model.location.latitude
        longitude = model.location.longitude

        if let openingHoursDetailsModel = model.openingHoursDetails {
            openingHoursDetails = ManagedOpeningHoursDetails(openingHoursDetailsModel, for: context)
        }

        model.photos.forEach {
            photos.adding(ManagedPhoto($0, for: context))
        }
    }
}

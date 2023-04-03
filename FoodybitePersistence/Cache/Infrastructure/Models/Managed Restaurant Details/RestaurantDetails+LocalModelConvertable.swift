//
//  RestaurantDetails+LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import CoreData

extension RestaurantDetails: LocalModelConvertable {
    public init(from managedRestaurantDetails: ManagedRestaurantDetails) {
        var openingHoursDetails: OpeningHoursDetails?
        
        if let openingHoursDetailsModel = managedRestaurantDetails.openingHoursDetails {
            if let weekdayTextArray = openingHoursDetailsModel.weekdayText.allObjects as? [String] {
                openingHoursDetails = OpeningHoursDetails(openNow: openingHoursDetailsModel.openNow,
                                                          weekdayText: weekdayTextArray)
            }
        }
        
        let managedPhotos = managedRestaurantDetails.photos.allObjects as! [ManagedPhoto]
        let photos = managedPhotos.map {
            Photo(width: Int($0.width), height: Int($0.height), photoReference: $0.reference)
        }
        
        self.init(id: managedRestaurantDetails.id,
                  phoneNumber: managedRestaurantDetails.phoneNumber,
                  name: managedRestaurantDetails.name,
                  address: managedRestaurantDetails.address,
                  rating: managedRestaurantDetails.rating,
                  openingHoursDetails: openingHoursDetails,
                  reviews: [],
                  location: Location(
                    latitude: managedRestaurantDetails.latitude,
                    longitude: managedRestaurantDetails.longitude),
                  photos: photos)
    }
    
    public func toLocalModel(context: NSManagedObjectContext) -> ManagedRestaurantDetails {
        ManagedRestaurantDetails(self, for: context)
    }
}

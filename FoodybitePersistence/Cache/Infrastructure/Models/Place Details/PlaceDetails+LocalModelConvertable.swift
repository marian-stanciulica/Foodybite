//
//  PlaceDetails+LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import CoreData

extension PlaceDetails: LocalModelConvertable {
    public init(from managedNearbyPlace: ManagedPlaceDetails) {
        var openingHoursDetails: OpeningHoursDetails?
        
        if let openingHoursDetailsModel = managedNearbyPlace.openingHoursDetails {
            if let weekdayTextArray = openingHoursDetailsModel.weekdayText?.allObjects as? [String] {
                openingHoursDetails = OpeningHoursDetails(openNow: openingHoursDetailsModel.openNow,
                                                          weekdayText: weekdayTextArray)
            }
        }
        
        self.init(placeID: managedNearbyPlace.placeID,
                  phoneNumber: managedNearbyPlace.phoneNumber,
                  name: managedNearbyPlace.name,
                  address: managedNearbyPlace.address,
                  rating: managedNearbyPlace.rating,
                  openingHoursDetails: openingHoursDetails,
                  reviews: [],
                  location: Location(
                    latitude: managedNearbyPlace.latitude,
                    longitude: managedNearbyPlace.longitude),
                  photos: [])
    }
    
    public func toLocalModel(context: NSManagedObjectContext) -> ManagedPlaceDetails {
        ManagedPlaceDetails(self, for: context)
    }
}

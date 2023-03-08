//
//  PlaceDetails+LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import CoreData

extension PlaceDetails: LocalModelConvertable {
    public init(from managedPlaceDetails: ManagedPlaceDetails) {
        var openingHoursDetails: OpeningHoursDetails?
        
        if let openingHoursDetailsModel = managedPlaceDetails.openingHoursDetails {
            if let weekdayTextArray = openingHoursDetailsModel.weekdayText?.allObjects as? [String] {
                openingHoursDetails = OpeningHoursDetails(openNow: openingHoursDetailsModel.openNow,
                                                          weekdayText: weekdayTextArray)
            }
        }
        
        self.init(placeID: managedPlaceDetails.placeID,
                  phoneNumber: managedPlaceDetails.phoneNumber,
                  name: managedPlaceDetails.name,
                  address: managedPlaceDetails.address,
                  rating: managedPlaceDetails.rating,
                  openingHoursDetails: openingHoursDetails,
                  reviews: [],
                  location: Location(
                    latitude: managedPlaceDetails.latitude,
                    longitude: managedPlaceDetails.longitude),
                  photos: [])
    }
    
    public func toLocalModel(context: NSManagedObjectContext) -> ManagedPlaceDetails {
        ManagedPlaceDetails(self, for: context)
    }
}

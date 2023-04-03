//
//  PlaceDetails+LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import CoreData

extension RestaurantDetails: LocalModelConvertable {
    public init(from managedPlaceDetails: ManagedPlaceDetails) {
        var openingHoursDetails: OpeningHoursDetails?
        
        if let openingHoursDetailsModel = managedPlaceDetails.openingHoursDetails {
            if let weekdayTextArray = openingHoursDetailsModel.weekdayText.allObjects as? [String] {
                openingHoursDetails = OpeningHoursDetails(openNow: openingHoursDetailsModel.openNow,
                                                          weekdayText: weekdayTextArray)
            }
        }
        
        let managedPhotos = managedPlaceDetails.photos.allObjects as! [ManagedPhoto]
        let photos = managedPhotos.map {
            Photo(width: Int($0.width), height: Int($0.height), photoReference: $0.reference)
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
                  photos: photos)
    }
    
    public func toLocalModel(context: NSManagedObjectContext) -> ManagedPlaceDetails {
        ManagedPlaceDetails(self, for: context)
    }
}

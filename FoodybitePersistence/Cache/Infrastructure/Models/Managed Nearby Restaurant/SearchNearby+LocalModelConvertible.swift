//
//  SearchNearby+LocalModelConvertible.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Domain
import CoreData

extension NearbyRestaurant: LocalModelConvertable {
    public init(from managedNearbyRestaurant: ManagedNearbyRestaurant) {
        var photo: Photo? = nil
        
        if let managedPhoto = managedNearbyRestaurant.photo {
            photo = Photo(
                width: Int(managedPhoto.width),
                height: Int(managedPhoto.height),
                photoReference: managedPhoto.reference
            )
        }
        
        self.init(placeID: managedNearbyRestaurant.placeID,
                  placeName: managedNearbyRestaurant.placeName,
                  isOpen: managedNearbyRestaurant.isOpen,
                  rating: managedNearbyRestaurant.rating,
                  location: Location(latitude: managedNearbyRestaurant.latitude, longitude: managedNearbyRestaurant.longitude),
                  photo: photo)
    }
    
    public func toLocalModel(context: NSManagedObjectContext) -> ManagedNearbyRestaurant {
        ManagedNearbyRestaurant(self, for: context)
    }
}

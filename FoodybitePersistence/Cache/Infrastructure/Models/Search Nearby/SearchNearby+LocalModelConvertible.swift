//
//  SearchNearby+LocalModelConvertible.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Domain
import CoreData

extension NearbyPlace: LocalModelConvertable {
    public init(from managedNearbyPlace: ManagedNearbyPlace) {
        var photo: Photo? = nil
        
        if let managedPhoto = managedNearbyPlace.photo {
            photo = Photo(
                width: Int(managedPhoto.width),
                height: Int(managedPhoto.height),
                photoReference: managedPhoto.reference
            )
        }
        
        self.init(placeID: managedNearbyPlace.placeID,
                  placeName: managedNearbyPlace.placeName,
                  isOpen: managedNearbyPlace.isOpen,
                  rating: managedNearbyPlace.rating,
                  location: Location(latitude: managedNearbyPlace.latitude, longitude: managedNearbyPlace.longitude),
                  photo: photo)
    }
    
    public func toLocalModel(context: NSManagedObjectContext) -> ManagedNearbyPlace {
        ManagedNearbyPlace(self, for: context)
    }
}

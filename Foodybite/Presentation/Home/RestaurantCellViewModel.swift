//
//  RestaurantCellViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import Foundation
import DomainModels

public final class RestaurantCellViewModel: ObservableObject {
    private let nearbyPlace: NearbyPlace
    private let fetchPhotoService: FetchPlacePhotoService
    private let currentLocation: Location
    
    @Published public var imageData: Data?
    
    public init(nearbyPlace: NearbyPlace, fetchPhotoService: FetchPlacePhotoService, currentLocation: Location) {
        self.nearbyPlace = nearbyPlace
        self.fetchPhotoService = fetchPhotoService
        self.currentLocation = currentLocation
    }
    
    public var isOpen: Bool {
        nearbyPlace.isOpen
    }
    
    public var placeName: String {
        nearbyPlace.placeName
    }
    
    public var rating: String {
        String(format: "%.1f", nearbyPlace.rating)
    }
    
    public var distanceInKmFromCurrentLocation: String {
        let distance = DistanceSolver.getDistanceInKm(from: currentLocation, to: nearbyPlace.location)
        return "\(distance)"
    }
    
    @MainActor public func fetchPhoto() async {
        if let photo = nearbyPlace.photo {
            imageData = try? await fetchPhotoService.fetchPlacePhoto(photoReference: photo.photoReference)
        }
    }
}

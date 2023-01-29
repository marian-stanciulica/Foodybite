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
    
    @Published public var imageData: Data?
    
    public init(nearbyPlace: NearbyPlace, fetchPhotoService: FetchPlacePhotoService) {
        self.nearbyPlace = nearbyPlace
        self.fetchPhotoService = fetchPhotoService
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
        let source = Location(latitude: 44.437367393150396, longitude: 26.02757207676153)
        let distance = DistanceSolver.getDistanceInKm(from: source, to: nearbyPlace.location)
        return "\(distance)"
    }
    
    @MainActor public func fetchPhoto() async {
        imageData = try? await fetchPhotoService.fetchPlacePhoto(photoReference: nearbyPlace.photo!.photoReference)
    }
}

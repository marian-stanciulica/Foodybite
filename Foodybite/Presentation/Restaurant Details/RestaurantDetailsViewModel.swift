//
//  RestaurantDetailsViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation
import DomainModels
import UIKit
import FoodybiteNetworking

public final class RestaurantDetailsViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    private let placeID: String
    private let currentLocation: Location
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let fetchPhotoService: FetchPlacePhotoService
    private let getReviewsService: GetReviewsService
    
    @Published public var error: Error?
    @Published public var placeDetails: PlaceDetails?
    @Published public var imageData: Data?
    @Published public var photosData = [Data?]()
    
    public var rating: String {
        guard let placeDetails = placeDetails else { return "" }
        
        return String(format: "%.1f", placeDetails.rating)
    }
    
    public var distanceInKmFromCurrentLocation: String {
        guard let placeDetails = placeDetails else { return "" }
        
        let distance = DistanceSolver.getDistanceInKm(from: currentLocation, to: placeDetails.location)
        return "\(distance)"
    }
    
    public init(placeID: String, currentLocation: Location, getPlaceDetailsService: GetPlaceDetailsService, fetchPhotoService: FetchPlacePhotoService, getReviewsService: GetReviewsService) {
        self.placeID = placeID
        self.currentLocation = currentLocation
        self.getPlaceDetailsService = getPlaceDetailsService
        self.fetchPhotoService = fetchPhotoService
        self.getReviewsService = getReviewsService
    }
    
    public func showMaps() {
        guard let location = placeDetails?.location else { return }
        guard let url = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @MainActor public func getPlaceDetails() async {
        do {
            error = nil
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
            
            photosData = Array(repeating: nil, count: placeDetails.photos.count - 1)
            
            if let firstPhoto = placeDetails.photos.first {
                imageData = await fetchPhoto(firstPhoto)
            }
            
            self.placeDetails = placeDetails
        } catch {
            placeDetails = nil
            self.error = .connectionFailure
        }
    }
    
    public func getPlaceReviews() async {
        if let reviews = try? await getReviewsService.getReviews(placeID: placeID) {
            placeDetails?.reviews += reviews
        }
    }
    
    @MainActor public func fetchPhoto(_ photo: Photo) async -> Data? {
        return try? await fetchPhotoService.fetchPlacePhoto(photoReference: photo.photoReference)
    }
    
    @MainActor public func fetchPhoto(at index: Int) async {
        if let placeDetails = placeDetails {
            photosData[index] = await fetchPhoto(placeDetails.photos[index + 1])
        }
    }
}

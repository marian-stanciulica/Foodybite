//
//  SelectedRestaurantViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 11.02.2023.
//

import Foundation
import Domain

public final class SelectedRestaurantViewModel: ObservableObject {
    public enum State: Equatable {
        case idle
        case isLoading
        case loadingError(String)
        case requestSucceeeded(Data)
    }
    
    private let placeDetails: PlaceDetails
    private let fetchPlacePhotoService: FetchPlacePhotoService
    
    public var placeName: String {
        placeDetails.name
    }
    
    public var placeAddress: String {
        placeDetails.address
    }
    
    @Published public var fetchPhotoState: State = .idle
    
    public init(placeDetails: PlaceDetails, fetchPlacePhotoService: FetchPlacePhotoService) {
        self.placeDetails = placeDetails
        self.fetchPlacePhotoService = fetchPlacePhotoService
    }
    
    public func fetchPhoto() async {
        fetchPhotoState = .isLoading
        
        guard let firstPhoto = placeDetails.photos.first else {
            fetchPhotoState = .loadingError("This place has no photos!")
            return
        }
        
        do {
            let photoData = try await fetchPlacePhotoService.fetchPlacePhoto(photoReference: firstPhoto.photoReference)
            fetchPhotoState = .requestSucceeeded(photoData)
        } catch {
            fetchPhotoState = .loadingError("An error occured while fetching place photo. Please try again later!")
        }
    }
}


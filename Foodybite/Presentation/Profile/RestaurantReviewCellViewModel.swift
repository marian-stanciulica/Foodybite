//
//  RestaurantReviewCellViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import Foundation
import Domain

public class RestaurantReviewCellViewModel: ObservableObject {
    public enum State<T>: Equatable where T: Equatable {
        case isLoading
        case loadingError(String)
        case requestSucceeeded(T)
    }
    
    private let placeID: String
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let fetchPlacePhotoService: FetchPlacePhotoService
    
    @Published public var getPlaceDetailsState: State<PlaceDetails> = .isLoading
    @Published public var fetchPhotoState: State<Data> = .isLoading
    
    public var rating: String {
        if case let .requestSucceeeded(placeDetails) = getPlaceDetailsState {
            return String(format: "%.1f", placeDetails.rating)
        }
        return ""
    }
    
    public var placeName: String {
        if case let .requestSucceeeded(placeDetails) = getPlaceDetailsState {
            return placeDetails.name
        }
        return ""
    }
    
    public var placeAddress: String {
        if case let .requestSucceeeded(placeDetails) = getPlaceDetailsState {
            return placeDetails.address
        }
        return ""
    }
    
    public init(placeID: String, getPlaceDetailsService: GetPlaceDetailsService, fetchPlacePhotoService: FetchPlacePhotoService) {
        self.placeID = placeID
        self.getPlaceDetailsService = getPlaceDetailsService
        self.fetchPlacePhotoService = fetchPlacePhotoService
    }
    
    public func getPlaceDetails() async {
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
            getPlaceDetailsState = .requestSucceeeded(placeDetails)
            
            if let firstPhoto = placeDetails.photos.first {
                await fetchPhoto(firstPhoto)
            }
        } catch {
            getPlaceDetailsState = .loadingError("An error occured while fetching review details. Please try again later!")
        }
    }
    
    private func fetchPhoto(_ photo: Photo) async {
        do {
            let photoData = try await fetchPlacePhotoService.fetchPlacePhoto(photoReference: photo.photoReference)
            fetchPhotoState = .requestSucceeeded(photoData)
        } catch {
            fetchPhotoState = .loadingError("An error occured while fetching place photo. Please try again later!")
        }
    }
}

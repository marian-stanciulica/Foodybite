//
//  RestaurantReviewCellViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import Foundation
import Domain

public class RestaurantReviewCellViewModel: ObservableObject {
    public enum GetPlaceDetailsError: String, Error {
        case serverError = "An error occured while fetching review details. Please try again later!"
    }
    
    public enum FetchPhotoError: String, Error {
        case serverError = "An error occured while fetching place photo. Please try again later!"
    }
    
    public enum State<T, E: Error>: Equatable where T: Equatable, E: Equatable {
        case idle
        case isLoading
        case failure(E)
        case success(T)
    }
    
    private let review: Review
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let fetchPlacePhotoService: FetchPlacePhotoService
    
    @Published public var getPlaceDetailsState: State<PlaceDetails, GetPlaceDetailsError> = .idle
    @Published public var fetchPhotoState: State<Data, FetchPhotoError> = .idle
    
    public var rating: String {
        "\(review.rating)"
    }
    
    public var placeName: String {
        if case let .success(placeDetails) = getPlaceDetailsState {
            return placeDetails.name
        }
        return ""
    }
    
    public var placeAddress: String {
        if case let .success(placeDetails) = getPlaceDetailsState {
            return placeDetails.address
        }
        return ""
    }
    
    public init(review: Review, getPlaceDetailsService: GetPlaceDetailsService, fetchPlacePhotoService: FetchPlacePhotoService) {
        self.review = review
        self.getPlaceDetailsService = getPlaceDetailsService
        self.fetchPlacePhotoService = fetchPlacePhotoService
    }
    
    @MainActor public func getPlaceDetails() async {
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: review.placeID)
            getPlaceDetailsState = .success(placeDetails)
            
            if let firstPhoto = placeDetails.photos.first {
                await fetchPhoto(firstPhoto)
            }
        } catch {
            getPlaceDetailsState = .failure(.serverError)
        }
    }
    
    @MainActor private func fetchPhoto(_ photo: Photo) async {
        do {
            let photoData = try await fetchPlacePhotoService.fetchPlacePhoto(photoReference: photo.photoReference)
            fetchPhotoState = .success(photoData)
        } catch {
            fetchPhotoState = .failure(.serverError)
        }
    }
}

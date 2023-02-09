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
    
    private let review: Review
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let fetchPlacePhotoService: FetchPlacePhotoService
    
    @Published public var getPlaceDetailsState: State<PlaceDetails> = .isLoading
    @Published public var fetchPhotoState: State<Data> = .isLoading
    
    public var rating: String {
        "\(review.rating)"
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
    
    public init(review: Review, getPlaceDetailsService: GetPlaceDetailsService, fetchPlacePhotoService: FetchPlacePhotoService) {
        self.review = review
        self.getPlaceDetailsService = getPlaceDetailsService
        self.fetchPlacePhotoService = fetchPlacePhotoService
    }
    
    public func getPlaceDetails() async {
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: review.placeID)
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

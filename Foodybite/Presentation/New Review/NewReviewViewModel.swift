//
//  NewReviewViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import Foundation
import Domain

public final class NewReviewViewModel: ObservableObject {
    public enum State<T>: Equatable where T: Equatable {
        case idle
        case isLoading
        case loadingError(String)
        case requestSucceeeded(T)
    }
    
    public enum ReviewState: Equatable {
        case idle
        case isLoading
        case loadingError(String)
        case requestSucceeeded
    }
    
    private let autocompletePlacesService: AutocompletePlacesService
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let fetchPlacePhotoService: FetchPlacePhotoService
    private let addReviewService: AddReviewService
    private let location: Location
    
    @Published public var getPlaceDetailsState: State<PlaceDetails> = .idle
    @Published public var fetchPhotoState: State<Data> = .idle
    @Published public var postReviewState: ReviewState = .idle
    
    @Published public var searchText = ""
    @Published public var reviewText = ""
    @Published public var starsNumber = 0
    @Published public var autocompleteResults = [AutocompletePrediction]()
    
    public var postReviewEnabled: Bool {
        if case .requestSucceeeded = getPlaceDetailsState {
            return !reviewText.isEmpty && starsNumber > 0
        }
        return false
    }
    
    public init(autocompletePlacesService: AutocompletePlacesService, getPlaceDetailsService: GetPlaceDetailsService, fetchPlacePhotoService: FetchPlacePhotoService, addReviewService: AddReviewService, location: Location) {
        self.autocompletePlacesService = autocompletePlacesService
        self.getPlaceDetailsService = getPlaceDetailsService
        self.fetchPlacePhotoService = fetchPlacePhotoService
        self.addReviewService = addReviewService
        self.location = location
    }
    
    public func autocomplete() async {
        getPlaceDetailsState = .idle
        fetchPhotoState = .idle
        
        do {
            autocompleteResults = try await autocompletePlacesService.autocomplete(input: searchText, location: location, radius: 100)
        } catch {
            autocompleteResults = []
        }
    }
    
    public func getPlaceDetails(placeID: String) async {
        getPlaceDetailsState = .isLoading
        
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
            getPlaceDetailsState = .requestSucceeeded(placeDetails)
            
            if let firstPhoto = placeDetails.photos.first {
                await fetchPhoto(firstPhoto)
            }
        } catch {
            getPlaceDetailsState = .loadingError("An error occured while fetching place details. Please try again later!")
        }
    }
    
    private func fetchPhoto(_ photo: Photo) async {
        fetchPhotoState = .isLoading
        
        do {
            let photoData = try await fetchPlacePhotoService.fetchPlacePhoto(photoReference: photo.photoReference)
            fetchPhotoState = .requestSucceeeded(photoData)
        } catch {
            fetchPhotoState = .loadingError("An error occured while fetching place photo. Please try again later!")
        }
    }
    
    public func postReview() async {
        guard postReviewEnabled else { return }
        postReviewState = .isLoading
        
        if case let .requestSucceeeded(placeDetails) = getPlaceDetailsState {
            do {
                try await addReviewService.addReview(
                    placeID: placeDetails.placeID,
                    reviewText: reviewText,
                    starsNumber: starsNumber,
                    createdAt: Date())
                
                postReviewState = .requestSucceeeded
            } catch {
                postReviewState = .loadingError("Review couldn't be posted. Please try again later!")
            }
        }
    }
}

//
//  HomeViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class HomeViewSnapshotTests: XCTestCase {
    
    func test_homeViewIdleState() {
        let sut = makeSUT(getNearbyPlacesState: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewLoadingState() {
        let sut = makeSUT(getNearbyPlacesState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewFailureState() {
        let sut = makeSUT(getNearbyPlacesState: .failure(.serverError))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewSuccessState() {
        let sut = makeSUT(getNearbyPlacesState: .success(makeNearbyPlaces()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewWhenGetNearbyPlaceStateIsSuccessAndFetchPhotoStateIsFailure() {
        let sut = makeSUT(getNearbyPlacesState: .success(makeNearbyPlaces()),
                          fetchPhotoState: .failure)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewWhenGetNearbyPlaceStateIsSuccessAndFetchPhotoStateIsSuccess() {
        let sut = makeSUT(getNearbyPlacesState: .success(makeNearbyPlaces()),
                          fetchPhotoState: .success(makePhotoData()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(getNearbyPlacesState: HomeViewModel.State, fetchPhotoState: PhotoViewModel.State = .isLoading) -> UIViewController {
        let currentLocation = Location(latitude: 0, longitude: 0)
        
        let homeViewModel = HomeViewModel(searchNearbyService: EmptySearchNearbyService(), currentLocation: currentLocation)
        homeViewModel.searchNearbyState = getNearbyPlacesState
        
        let photoViewModel = PhotoViewModel(
            photoReference: "reference",
            fetchPhotoService: EmptyFetchPlacePhotoService()
        )
        photoViewModel.fetchPhotoState = fetchPhotoState
        
        let homeView = HomeView(viewModel: homeViewModel, showPlaceDetails: { _ in }) { nearbyPlace in
            RestaurantCell(
                photoView: PhotoView(viewModel: photoViewModel),
                viewModel: RestaurantCellViewModel(
                    nearbyPlace: nearbyPlace,
                    currentLocation: currentLocation
                )
            )
        }
        let sut = UIHostingController(rootView: homeView)
        return sut
    }
    
    private func makeNearbyPlaces() -> [NearbyPlace] {
        [
            NearbyPlace(
                placeID: "place #1",
                placeName: "Place name 1",
                isOpen: true,
                rating: 3,
                location: Location(latitude: 2, longitude: 5),
                photo: nil),
            NearbyPlace(
                placeID: "place #2",
                placeName: "Place name 2",
                isOpen: false,
                rating: 4,
                location: Location(latitude: 43, longitude: 56),
                photo: nil),
            NearbyPlace(
                placeID: "place #3",
                placeName: "Place name 3",
                isOpen: true,
                rating: 5,
                location: Location(latitude: 3, longitude: 6),
                photo: nil)
        ]
    }
    
    private class EmptySearchNearbyService: SearchNearbyService {
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] { [] }
    }
}
 

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
        let sut = makeSUT(state: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewLoadingState() {
        let sut = makeSUT(state: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_homeViewFailureState() {
        let sut = makeSUT(state: .failure(.serverError))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(state: HomeViewModel.State) -> UIViewController {
        let currentLocation = Location(latitude: 0, longitude: 0)
        
        let homeViewModel = HomeViewModel(searchNearbyService: EmptySearchNearbyService(), currentLocation: currentLocation)
        homeViewModel.searchNearbyState = state
        
        let homeView = HomeView(viewModel: homeViewModel, showPlaceDetails: { _ in }) { nearbyPlace in
            RestaurantCell(
                photoView: PhotoView(
                    viewModel: PhotoViewModel(
                        photoReference: nearbyPlace.photo?.photoReference,
                        fetchPhotoService: EmptyFetchPlacePhotoService()
                    )
                ),
                viewModel: RestaurantCellViewModel(
                    nearbyPlace: nearbyPlace,
                    currentLocation: currentLocation
                )
            )
        }
        let sut = UIHostingController(rootView: homeView)
        return sut
    }
    
    private class EmptySearchNearbyService: SearchNearbyService {
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] { [] }
    }
    
    private class EmptyFetchPlacePhotoService: FetchPlacePhotoService {
        func fetchPlacePhoto(photoReference: String) async throws -> Data { Data() }
    }
}
 

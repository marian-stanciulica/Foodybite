//
//  RestaurantCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import XCTest
import Foodybite
import DomainModels

final class RestaurantCellViewModel {
    private let nearbyPlace: NearbyPlace
    
    init(nearbyPlace: NearbyPlace) {
        self.nearbyPlace = nearbyPlace
    }
    
    var rating: String {
        String(format: "%.1f", nearbyPlace.rating)
    }
    
    var distanceInKmFromCurrentLocation: String {
        let source = Location(latitude: 44.437367393150396, longitude: 26.02757207676153)
        let distance = DistanceSolver.getDistanceInKm(from: source, to: nearbyPlace.location)
        return "\(distance)"
    }
}

final class RestaurantCellViewModelTests: XCTestCase {
    
    func test_rating_returnsFormmatedRating() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.rating, rating().formatted)
    }
    
    func test_distanceInKmFromCurrentLocation_computedCorrectly() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.distanceInKmFromCurrentLocation, "6.5")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> RestaurantCellViewModel {
        RestaurantCellViewModel(
            nearbyPlace: NearbyPlace(
                placeID: UUID().uuidString,
                placeName: "Place name",
                isOpen: true,
                rating: rating().raw,
                location: Location(latitude: 44.4, longitude: 26.09)
            )
        )
    }
    
    private func rating() -> (raw: Double, formatted: String) {
        (4.52, "4.5")
    }
    
}

//
//  RestaurantCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import XCTest
import Foodybite
import DomainModels

final class RestaurantCellViewModelTests: XCTestCase {
    
    func test_rating_returnsFormmatedRating() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.rating, rating().formatted)
    }
    
    func test_distanceInKmFromCurrentLocation_computedCorrectly() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.distanceInKmFromCurrentLocation, "6.5")
    }
    
    func test_isOpen_equalsNearbyPlaceIsOpen() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.isOpen, isOpen())
    }
    
    func test_placeName_equalsNearbyPlaceName() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.placeName, anyPlaceName())
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> RestaurantCellViewModel {
        RestaurantCellViewModel(
            nearbyPlace: NearbyPlace(
                placeID: UUID().uuidString,
                placeName: anyPlaceName(),
                isOpen: isOpen(),
                rating: rating().raw,
                location: Location(latitude: 44.4, longitude: 26.09)
            )
        )
    }
    
    private func rating() -> (raw: Double, formatted: String) {
        (4.52, "4.5")
    }
    
    private func isOpen() -> Bool {
        return true
    }
    
    private func anyPlaceName() -> String {
        "Place name"
    }
    
}

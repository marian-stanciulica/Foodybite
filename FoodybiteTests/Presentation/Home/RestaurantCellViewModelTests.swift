//
//  RestaurantCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import XCTest
import DomainModels

final class RestaurantCellViewModel {
    private let nearbyPlace: NearbyPlace
    
    init(nearbyPlace: NearbyPlace) {
        self.nearbyPlace = nearbyPlace
    }
    
    var rating: String {
        String(format: "%.1f", nearbyPlace.rating)
    }
}

final class RestaurantCellViewModelTests: XCTestCase {
    
    func test_rating_returnsFormmatedRating() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.rating, rating().formatted)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> RestaurantCellViewModel {
        RestaurantCellViewModel(
            nearbyPlace: NearbyPlace(
                placeID: UUID().uuidString,
                placeName: "Place name",
                isOpen: true,
                rating: rating().raw
            )
        )
    }
    
    private func rating() -> (raw: Double, formatted: String) {
        (4.52, "4.5")
    }
    
}

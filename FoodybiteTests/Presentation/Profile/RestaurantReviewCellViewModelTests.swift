//
//  RestaurantReviewCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import XCTest
import Domain

class RestaurantReviewCellViewModel {
    private let placeID: String
    private let getPlaceDetailsService: GetPlaceDetailsService
    
    init(placeID: String, getPlaceDetailsService: GetPlaceDetailsService) {
        self.placeID = placeID
        self.getPlaceDetailsService = getPlaceDetailsService
    }
    
    func getPlaceDetails() async {
        _ = try? await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
    }
}

final class RestaurantReviewCellViewModelTests: XCTestCase {
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let anyPlaceID = anyPlaceID()
        let (sut, getPlaceDetailsServiceSpy) = makeSUT(placeID: anyPlaceID)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.first, anyPlaceID)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeID: String = "") -> (sut: RestaurantReviewCellViewModel,
                               getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy) {
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let sut = RestaurantReviewCellViewModel(placeID: placeID, getPlaceDetailsService: getPlaceDetailsServiceSpy)
        return (sut, getPlaceDetailsServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var capturedValues = [String]()
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            capturedValues.append(placeID)
            return PlaceDetails(phoneNumber: nil, name: "", address: "", rating: 0, openingHoursDetails: nil, reviews: [], location: Location(latitude: 0, longitude: 0), photos: [])
        }
    }
    
}

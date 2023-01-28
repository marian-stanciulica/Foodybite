//
//  RestaurantDetailsViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import Foundation
import DomainModels

final class RestaurantDetailsViewModel {
    private let getPlaceDetailsService: GetPlaceDetailsService
    
    init(getPlaceDetailsService: GetPlaceDetailsService) {
        self.getPlaceDetailsService = getPlaceDetailsService
    }
    
    func getPlaceDetails(placeID: String) async -> PlaceDetails {
        _ = try? await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
        return PlaceDetails(name: "any place")
    }
}

final class RestaurantDetailsViewModelTests: XCTestCase {
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let (sut, serviceSpy) = makeSUT()
        let expectedPlaceID = anyPlaceID
        
        _ = await sut.getPlaceDetails(placeID: expectedPlaceID)
        
        XCTAssertEqual(serviceSpy.placeID, expectedPlaceID)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RestaurantDetailsViewModel, serviceSpy: GetPlaceDetailsServiceSpy) {
        let serviceSpy = GetPlaceDetailsServiceSpy()
        let sut = RestaurantDetailsViewModel(getPlaceDetailsService: serviceSpy)
        return (sut, serviceSpy)
    }
    
    private var anyPlaceID: String {
        UUID().uuidString
    }
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var placeID: String?
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            self.placeID = placeID
            
            return PlaceDetails(name: "any place")
        }
    }
    
}

//
//  RestaurantDetailsViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import Foodybite
import DomainModels

final class RestaurantDetailsViewModelTests: XCTestCase {
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let (sut, serviceSpy) = makeSUT()
        serviceSpy.result = .failure(anyError)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(serviceSpy.placeID, anyPlaceID())
    }
    
    func test_getPlaceDetails_setsErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, serviceSpy) = makeSUT()
        
        serviceSpy.result = .failure(anyError)
        await sut.getPlaceDetails()
        XCTAssertEqual(sut.error, .connectionFailure)
    }
    
    func test_getPlaceDetails_updatesPlaceDetailsWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, serviceSpy) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails
        
        serviceSpy.result = .success(expectedPlaceDetails)
        await sut.getPlaceDetails()
        
        XCTAssertEqual(sut.placeDetails, expectedPlaceDetails)
        XCTAssertNil(sut.error)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RestaurantDetailsViewModel, serviceSpy: GetPlaceDetailsServiceSpy) {
        let serviceSpy = GetPlaceDetailsServiceSpy()
        let sut = RestaurantDetailsViewModel(placeID: anyPlaceID(), getPlaceDetailsService: serviceSpy)
        return (sut, serviceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private var anyPlaceDetails: PlaceDetails {
        PlaceDetails(
            phoneNumber: "+61 2 9374 4000",
            name: "Place name",
            address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia",
            rating: 4.5
        )
    }
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var placeID: String?
        var result: Result<PlaceDetails, Error>!
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            self.placeID = placeID
            return try result.get()
        }
    }
    
}

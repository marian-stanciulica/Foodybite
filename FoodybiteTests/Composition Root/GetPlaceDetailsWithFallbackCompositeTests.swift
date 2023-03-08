//
//  GetPlaceDetailsWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import Foodybite

final class GetPlaceDetailsWithFallbackComposite: GetPlaceDetailsService {
    private let primary: GetPlaceDetailsService
    private let secondary: GetPlaceDetailsService
    
    init(primary: GetPlaceDetailsService, secondary: GetPlaceDetailsService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        try await primary.getPlaceDetails(placeID: placeID)
    }
}

final class GetPlaceDetailsWithFallbackCompositeTests: XCTestCase {
    
    func test_getPlaceDetails_returnsPlaceDetailsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedPlaceDetails = makeExpectedPlaceDetails()
        primaryStub.stub = .success(expectedPlaceDetails)
        
        let receivedPlaceDetails = try await sut.getPlaceDetails(placeID: expectedPlaceDetails.placeID)
        
        XCTAssertEqual(receivedPlaceDetails, expectedPlaceDetails)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetPlaceDetailsWithFallbackComposite, primaryStub: GetPlaceDetailsServiceStub, secondaryStub: GetPlaceDetailsServiceStub) {
        let primaryStub = GetPlaceDetailsServiceStub()
        let secondaryStub = GetPlaceDetailsServiceStub()
        let sut = GetPlaceDetailsWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }
    
    private func makeExpectedPlaceDetails() -> PlaceDetails {
        PlaceDetails(placeID: "Expected place",
                     phoneNumber: "",
                     name: "",
                     address: "",
                     rating: 0,
                     openingHoursDetails: nil,
                     reviews: [],
                     location: Location(latitude: 0, longitude: 0),
                     photos: [])
    }
    
}


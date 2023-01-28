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
    public enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    private let placeID: String
    private let getPlaceDetailsService: GetPlaceDetailsService
    var error: Error?
    var placeDetails: PlaceDetails?
    
    init(placeID: String, getPlaceDetailsService: GetPlaceDetailsService) {
        self.placeID = placeID
        self.getPlaceDetailsService = getPlaceDetailsService
    }
    
    func getPlaceDetails() async {
        do {
            error = nil
            placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
        } catch {
            self.error = .connectionFailure
        }
    }
}

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
        PlaceDetails(name: "any place")
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

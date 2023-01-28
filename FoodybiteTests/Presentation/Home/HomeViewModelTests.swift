//
//  HomeViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import DomainModels
import FoodybitePlaces

final class HomeViewModel {
    enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    private let searchNearbyService: SearchNearbyService
    var error: Error?
    
    init(searchNearbyService: SearchNearbyService) {
        self.searchNearbyService = searchNearbyService
    }
    
    func searchNearby(location: Location, radius: Int) async {
        do {
            _ = try await searchNearbyService.searchNearby(location: location, radius: radius)
        } catch {
            self.error = .connectionFailure
        }
    }
}

final class HomeViewModelTests: XCTestCase {
    
    func test_searchNearby_sendsInputsToSearchNearbyService() async {
        let serviceSpy = SearchNearbyServiceSpy()
        let sut = HomeViewModel(searchNearbyService: serviceSpy)
        
        await sut.searchNearby(location: location, radius: radius)
        
        XCTAssertEqual(serviceSpy.capturedValues[0].radius, radius)
        XCTAssertEqual(serviceSpy.capturedValues[0].location, location)
    }
    
    func test_searchNearby_setsErrorWhenSearchNearbyServiceThrowsError() async {
        let serviceSpy = SearchNearbyServiceSpy()
        serviceSpy.errorToThrow = anyError
        let sut = HomeViewModel(searchNearbyService: serviceSpy)
        
        await sut.searchNearby(location: location, radius: radius)
        
        XCTAssertEqual(sut.error, .connectionFailure)
    }
    
    // MARK: - Helpers
    
    private var location: Location {
        Location(lat: -31.3223245, lng: 132.45432)
    }
    
    private var radius: Int {
        50
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private class SearchNearbyServiceSpy: SearchNearbyService {
        var errorToThrow: Error?
        private(set) var capturedValues = [(location: Location, radius: Int)]()
        
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
            capturedValues.append((location, radius))

            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
            
            return []
        }
    }
    
}

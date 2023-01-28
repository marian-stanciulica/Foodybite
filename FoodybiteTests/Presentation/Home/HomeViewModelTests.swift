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
    private let searchNearbyService: SearchNearbyService
    
    init(searchNearbyService: SearchNearbyService) {
        self.searchNearbyService = searchNearbyService
    }
    
    func searchNearby(location: Location, radius: Int) async {
        _ = try? await searchNearbyService.searchNearby(location: location, radius: radius)
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
    
    // MARK: - Helpers
    
    private var location: Location {
        Location(lat: -31.3223245, lng: 132.45432)
    }
    
    private var radius: Int {
        50
    }
    
    private class SearchNearbyServiceSpy: SearchNearbyService {
        private(set) var capturedValues = [(location: Location, radius: Int)]()
        
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
            capturedValues.append((location, radius))

            return []
        }
    }
    
}

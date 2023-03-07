//
//  SearchNearbyServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Domain
import XCTest

final class SearchNearbyServiceCacheDecorator: SearchNearbyService {
    private let searchNearbyService: SearchNearbyService
    
    init(searchNearbyService: SearchNearbyService) {
        self.searchNearbyService = searchNearbyService
    }
    
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        return try await searchNearbyService.searchNearby(location: location, radius: radius)
    }
}

final class SearchNearbyServiceCacheDecoratorTests: XCTestCase {
    
    func test_searchNearby_throwsErrorWhenSearchNearbyServiceThrowsError() async {
        let (sut, serviceStub) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        do {
            let nearbyPlaces = try await searchNearby(on: sut)
            XCTFail("Expected to fail, received nearby places \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: SearchNearbyServiceCacheDecorator, serviceStub: SearchNearbyServiceStub) {
        let serviceStub = SearchNearbyServiceStub()
        let sut = SearchNearbyServiceCacheDecorator(searchNearbyService: serviceStub)
        return (sut, serviceStub)
    }
    
    private func searchNearby(on sut: SearchNearbyServiceCacheDecorator, location: Location? = nil, radius: Int = 0) async throws -> [NearbyPlace] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
    
    private func anyLocation() -> Location {
        Location(latitude: 0, longitude: 0)
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private class SearchNearbyServiceStub: SearchNearbyService {
        var stub: Result<[NearbyPlace], Error>?
        
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
            if let stub = stub {
                return try stub.get()
            }
            
            return []
        }
    }
    
}

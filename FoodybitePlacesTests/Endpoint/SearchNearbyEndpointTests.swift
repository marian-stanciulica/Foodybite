//
//  SearchNearbyEndpointTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

final class SearchNearbyEndpointTests: XCTestCase {
    
    func test_searchNearby_path() {
        XCTAssertEqual(makeSUT().path, "/maps/api/place/nearbysearch/json")
    }
    
    func test_searchNearby_queryItems() throws {
        let location = Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        let sut = makeSUT(location: location, radius: radius)
        let urlRequest = try sut.createURLRequest()
        
        guard let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "location" })?.value, "\(location.latitude),\(location.longitude)")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "radius" })?.value, "\(radius)")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "type" })?.value, "restaurant")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "key" })?.value, sut.apiKey)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(location: Location = Location(latitude: 0, longitude: 0), radius: Int = 0) -> SearchNearbyEndpoint {
        return SearchNearbyEndpoint(location: location, radius: radius)
    }
}


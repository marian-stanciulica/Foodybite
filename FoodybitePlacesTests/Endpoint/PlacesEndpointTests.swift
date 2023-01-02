//
//  PlacesEndpointTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces

final class PlacesEndpointTests: XCTestCase {
    
    // MARK: - Autocomplete
    
    func test_autocomplete_baseURL() {
        XCTAssertEqual(makeAutocompleteSUT().host, "https://maps.googleapis.com/maps/api/place")
    }
    
    func test_autocomplete_path() {
        XCTAssertEqual(makeAutocompleteSUT().path, "/autocomplete/json")
    }
    
    func test_autocomplete_methodIsGet() {
        XCTAssertEqual(makeAutocompleteSUT().method, .get)
    }
    
    
    // MARK: - Helpers
    
    private func makeAutocompleteSUT() -> PlacesEndpoint {
        return PlacesEndpoint.autocomplete
    }
    
}

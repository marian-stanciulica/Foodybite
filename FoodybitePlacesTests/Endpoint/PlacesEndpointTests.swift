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
    
    func test_autocomplete_queryItems() throws {
        let input = "input"
        let sut = makeAutocompleteSUT(input: input)
        let urlRequest = try sut.createURLRequest()
        
        guard let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "input" })?.value, input)
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "key" })?.value, sut.apiKey)
    }
    
    func test_autocomplete_methodIsGet() {
        XCTAssertEqual(makeAutocompleteSUT().method, .get)
    }
    
    
    // MARK: - Helpers
    
    private func makeAutocompleteSUT(input: String = "") -> PlacesEndpoint {
        return PlacesEndpoint.autocomplete(input)
    }
    
}

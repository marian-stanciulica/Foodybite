//
//  PlacesEndpointTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

final class AutocompleteEndpointTests: XCTestCase {
    
    func test_autocomplete_path() {
        XCTAssertEqual(makeSUT().path, "/maps/api/place/autocomplete/json")
    }
    
    func test_autocomplete_queryItems() throws {
        let input = "Paris"
        let location = Domain.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        let sut = makeSUT(input: input, location: location, radius: radius)
        let urlRequest = try sut.createURLRequest()
        
        guard let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "input" })?.value, input)
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "location" })?.value, "\(location.latitude),\(location.longitude)")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "radius" })?.value, "\(radius)")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "type" })?.value, "restaurant")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "key" })?.value, sut.apiKey)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(input: String = "", location: Domain.Location = Domain.Location(latitude: 0, longitude: 0), radius: Int = 0) -> AutocompleteEndpoint {
        return AutocompleteEndpoint(input: input, location: location, radius: radius)
    }
}

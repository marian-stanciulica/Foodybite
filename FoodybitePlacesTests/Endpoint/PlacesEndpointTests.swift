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
        XCTAssertEqual(makeAutocompleteSUT().host, "maps.googleapis.com")
    }
    
    func test_autocomplete_path() {
        XCTAssertEqual(makeAutocompleteSUT().path, "/maps/api/place/autocomplete/json")
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
    
    // MARK: - Get Place Details
    
    func test_getPlaceDetails_baseURL() {
        XCTAssertEqual(makePlaceDetailsSUT().host, "maps.googleapis.com")
    }
    
    func test_getPlaceDetails_path() {
        XCTAssertEqual(makePlaceDetailsSUT().path, "/maps/api/place/details/json")
    }
    
    func test_getPlaceDetails_queryItems() throws {
        let placeID = randomString()
        let sut = makePlaceDetailsSUT(placeID: placeID)
        let urlRequest = try sut.createURLRequest()
        
        guard let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "place_id" })?.value, placeID)
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "key" })?.value, sut.apiKey)
    }
    
    func test_getPlaceDetails_methodIsGet() {
        XCTAssertEqual(makePlaceDetailsSUT().method, .get)
    }
    
    
    // MARK: - Helpers
    
    private func makeAutocompleteSUT(input: String = "") -> PlacesEndpoint {
        return PlacesEndpoint.autocomplete(input)
    }
    
    private func makePlaceDetailsSUT(placeID: String = "") -> PlacesEndpoint {
        return PlacesEndpoint.getPlaceDetails(placeID)
    }
    
}

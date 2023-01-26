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
        XCTAssertEqual(makeSearchNearbySUT().host, "maps.googleapis.com")
    }
    
    func test_autocomplete_path() {
        XCTAssertEqual(makeSearchNearbySUT().path, "/maps/api/place/nearbysearch/json")
    }
    
    func test_autocomplete_queryItems() throws {
        let location = Location(lat: -33.8670522, lng: 151.1957362)
        let radius = 1500
        let sut = makeSearchNearbySUT(location: location, radius: radius)
        let urlRequest = try sut.createURLRequest()
        
        guard let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "location" })?.value, "\(location.lat)%2C\(location.lng)")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "radius" })?.value, "\(radius)")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "type" })?.value, "restaurant")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "key" })?.value, sut.apiKey)
    }
    
    func test_autocomplete_methodIsGet() {
        XCTAssertEqual(makeSearchNearbySUT().method, .get)
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
    
    private func makeSearchNearbySUT(location: Location = Location(lat: 0, lng: 0), radius: Int = 0) -> PlacesEndpoint {
        return PlacesEndpoint.searchNearby(location: location, radius: radius)
    }
    
    private func makePlaceDetailsSUT(placeID: String = "") -> PlacesEndpoint {
        return PlacesEndpoint.getPlaceDetails(placeID)
    }
    
}

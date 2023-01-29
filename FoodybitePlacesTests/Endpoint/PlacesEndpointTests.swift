//
//  PlacesEndpointTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces
import DomainModels

final class PlacesEndpointTests: XCTestCase {
    
    // MARK: - Search Nearby
    
    func test_searchNearby_baseURL() {
        XCTAssertEqual(makeSearchNearbySUT().host, "maps.googleapis.com")
    }
    
    func test_searchNearby_path() {
        XCTAssertEqual(makeSearchNearbySUT().path, "/maps/api/place/nearbysearch/json")
    }
    
    func test_searchNearby_queryItems() throws {
        let location = DomainModels.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        let sut = makeSearchNearbySUT(location: location, radius: radius)
        let urlRequest = try sut.createURLRequest()
        
        guard let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "location" })?.value, "\(location.latitude),\(location.longitude)")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "radius" })?.value, "\(radius)")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "type" })?.value, "restaurant")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "key" })?.value, sut.apiKey)
    }
    
    func test_searchNearby_methodIsGet() {
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
    
    private func makeSearchNearbySUT(location: DomainModels.Location = DomainModels.Location(latitude: 0, longitude: 0), radius: Int = 0) -> PlacesEndpoint {
        return PlacesEndpoint.searchNearby(location: location, radius: radius)
    }
    
    private func makePlaceDetailsSUT(placeID: String = "") -> PlacesEndpoint {
        return PlacesEndpoint.getPlaceDetails(placeID)
    }
    
}

//
//  GetPlaceDetailsEndpointTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybitePlaces

final class GetPlaceDetailsEndpointTests: XCTestCase {
    
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
    
    // MARK: - Helpers
    
    private func makePlaceDetailsSUT(placeID: String = "") -> GetPlaceDetailsEndpoint {
        return GetPlaceDetailsEndpoint(placeID: placeID)
    }
}

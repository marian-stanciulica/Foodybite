//
//  GetPlacePhotoEndpointTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybitePlaces

final class GetPlacePhotoEndpointTests: XCTestCase {
    
    func test_getPlacePhoto_path() {
        XCTAssertEqual(makePlacePhotoSUT().path, "/maps/api/place/photo")
    }
    
    func test_getPlacePhoto_queryItems() throws {
        let photoReference = randomString()
        let sut = makePlacePhotoSUT(photoReference: photoReference)
        let urlRequest = try sut.createURLRequest()
        
        guard let url = urlRequest.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "photo_reference" })?.value, photoReference)
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "key" })?.value, sut.apiKey)
    }
    
    // MARK: - Helpers
    
    private func makePlacePhotoSUT(photoReference: String = "") -> GetPlacePhotoEndpoint {
        return GetPlacePhotoEndpoint(photoReference: photoReference)
    }
}

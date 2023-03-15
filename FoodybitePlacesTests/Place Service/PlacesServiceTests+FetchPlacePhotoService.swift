//
//  PlacesServiceTests+FetchPlacePhotoService.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

extension PlacesServiceTests {
    
    func test_conformsToFetchPlacePhotoService() {
        let (sut, _) = makeSUT(response: anyData())
        XCTAssertNotNil(sut as FetchPlacePhotoService)
    }
    
    func test_fetchPlacePhoto_usesGetPlacePhotoEndpointToCreateURLRequest() async throws {
        let photoReference = randomString()
        let (sut, loader) = makeSUT(response: anyData())
        let endpoint = GetPlacePhotoEndpoint(photoReference: photoReference)
        
        _ = try await sut.fetchPlacePhoto(photoReference: photoReference)
        
        XCTAssertEqual(loader.getDataRequests.count, 1)
        assertURLComponents(
            urlRequest: loader.getDataRequests[0],
            photoReference: photoReference,
            apiKey: endpoint.apiKey
        )
    }
    
    func test_fetchPlacePhoto_receivesExpectedPlacePhotoResponse() async throws {
        let response = anyData()
        let expectedData = anyData()
        let (sut, loader) = makeSUT(response: response)
        loader.data = expectedData
        
        let receivedResponse = try await sut.fetchPlacePhoto(photoReference: randomString())
        
        XCTAssertEqual(expectedData, receivedResponse)
    }
    
    // MARK: - Helpers
    
    private func assertURLComponents(
        urlRequest: URLRequest,
        photoReference: String,
        apiKey: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "photo_reference", value: photoReference),
            URLQueryItem(name: "maxwidth", value: "400")
        ]
        
        assertURLComponents(
            urlRequest: urlRequest,
            path: "/maps/api/place/photo",
            expectedQueryItems: expectedQueryItems,
            file: file,
            line: line)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
}

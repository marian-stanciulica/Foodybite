//
//  PlacesServiceTests+FetchPlacePhotoService.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
import Foundation.NSURLRequest
@testable import FoodybitePlaces
import Domain

extension PlacesServiceTests {

    @Test func conformsToRestaurantPhotoService() {
        let (sut, _) = makeSUT(response: anyData())
        #expect(sut as RestaurantPhotoService != nil)
    }

    @Test func fetchPhoto_usesGetPlacePhotoEndpointToCreateURLRequest() async throws {
        let photoReference = randomString()
        let (sut, loader) = makeSUT(response: anyData())
        let endpoint = GetPlacePhotoEndpoint(photoReference: photoReference)

        _ = try await sut.fetchPhoto(photoReference: photoReference)

        #expect(loader.getDataRequests.count == 1)
        assertURLComponents(
            urlRequest: loader.getDataRequests[0],
            photoReference: photoReference,
            apiKey: endpoint.apiKey
        )
    }

    @Test func fetchPhoto_receivesExpectedPlacePhotoResponse() async throws {
        let response = anyData()
        let expectedData = anyData()
        let (sut, loader) = makeSUT(response: response)
        loader.data = expectedData

        let receivedResponse = try await sut.fetchPhoto(photoReference: randomString())

        #expect(expectedData == receivedResponse)
    }

    // MARK: - Helpers

    private func assertURLComponents(
        urlRequest: URLRequest,
        photoReference: String,
        apiKey: String,
        sourceLocation: SourceLocation = #_sourceLocation
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
            sourceLocation: sourceLocation)
    }

    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }

}

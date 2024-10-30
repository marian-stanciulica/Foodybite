//
//  PlacesServiceTests+NearbyRestaurantsService.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
import Foundation.NSURLRequest
@testable import FoodybitePlaces
import Domain

extension PlacesServiceTests {

    @Test func conformsToNearbyRestaurantsService() {
        let (sut, _) = makeSUT(response: anySearchNearbyResponse())
        #expect(sut as NearbyRestaurantsService != nil)
    }

    @Test func searchNearby_usesSearchNearbyEndpointToCreateURLRequest() async throws {
        let location = Location(latitude: -33.8, longitude: 15.1)
        let radius = 15
        let (sut, loader) = makeSUT(response: anySearchNearbyResponse())
        let endpoint = SearchNearbyEndpoint(location: location, radius: radius)

        _ = try await searchNearby(on: sut, location: location, radius: radius)

        #expect(loader.getRequests.count == 1)
        assertURLComponents(
            urlRequest: loader.getRequests[0],
            location: location,
            radius: radius,
            apiKey: endpoint.apiKey
        )
    }

    @Test func searchNearby_throwsErrorWhenStatusIsNotOK() async {
        let failedResponse = anySearchNearbyResponse(status: .overQueryLimit)
        let (sut, _) = makeSUT(response: failedResponse)

        do {
            let nearbyRestaurants = try await searchNearby(on: sut)
            Issue.record("Expected to fail, got \(nearbyRestaurants) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func searchNearby_receiveExpectedSearchNearbyResponse() async throws {
        let successfulResponse = anySearchNearbyResponse()
        let (sut, _) = makeSUT(response: successfulResponse)

        let receivedNearbyRestaurants = try await searchNearby(on: sut)
        #expect(successfulResponse.nearbyRestaurants == receivedNearbyRestaurants)
    }

    // MARK: - Helpers

    private func searchNearby(on sut: PlacesService, location: Location? = nil, radius: Int? = nil) async throws -> [NearbyRestaurant] {
        let defaultLocation = Location(latitude: -33.8, longitude: 15.1)
        let defaultRadius = 15

        return try await sut.searchNearby(location: location ?? defaultLocation, radius: radius ?? defaultRadius)
    }

    private func assertURLComponents(
        urlRequest: URLRequest,
        location: Location,
        radius: Int,
        apiKey: String,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "type", value: "restaurant")
        ]

        assertURLComponents(
            urlRequest: urlRequest,
            path: "/maps/api/place/nearbysearch/json",
            expectedQueryItems: expectedQueryItems,
            sourceLocation: sourceLocation)
    }

    private func anySearchNearbyResponse(status: SearchNearbyStatus = .okStatus) -> SearchNearbyResponse {
        SearchNearbyResponse(results: [
            SearchNearbyResult(
                businessStatus: "",
                geometry: Geometry(
                    location: RemoteLocation(lat: 0, lng: 0),
                    viewport: Viewport(
                        northeast: RemoteLocation(lat: 0, lng: 0),
                        southwest: RemoteLocation(lat: 0, lng: 0))),
                icon: "",
                iconBackgroundColor: "",
                iconMaskBaseURI: "",
                name: "a place",
                openingHours: OpeningHours(openNow: true),
                photos: [],
                placeID: "#1",
                plusCode: PlusCode(compoundCode: "", globalCode: ""),
                priceLevel: 0,
                rating: 0,
                reference: "",
                scope: "",
                types: [],
                userRatingsTotal: 0,
                vicinity: ""
            ),
            SearchNearbyResult(
                businessStatus: "",
                geometry: Geometry(
                    location: RemoteLocation(lat: 0, lng: 0),
                    viewport: Viewport(
                        northeast: RemoteLocation(lat: 0, lng: 0),
                        southwest: RemoteLocation(lat: 0, lng: 0))),
                icon: "",
                iconBackgroundColor: "",
                iconMaskBaseURI: "",
                name: "a place",
                openingHours: nil,
                photos: [],
                placeID: "#1",
                plusCode: PlusCode(compoundCode: "", globalCode: ""),
                priceLevel: 0,
                rating: nil,
                reference: "",
                scope: "",
                types: [],
                userRatingsTotal: 0,
                vicinity: ""
            )
        ], status: status)
    }

}

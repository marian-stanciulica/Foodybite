//
//  PlacesServiceTests+SearchNearbyService.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

extension PlacesServiceTests {
    
    func test_conformsToSearchNearbyService() {
        let (sut, _) = makeSUT(response: anySearchNearbyResponse())
        XCTAssertNotNil(sut as SearchNearbyService)
    }
    
    func test_searchNearby_usesSearchNearbyEndpointToCreateURLRequest() async throws {
        let location = Location(latitude: -33.8, longitude: 15.1)
        let radius = 15
        let (sut, loader) = makeSUT(response: anySearchNearbyResponse())
        let endpoint = SearchNearbyEndpoint(location: location, radius: radius)

        _ = try await searchNearby(on: sut, location: location, radius: radius)

        XCTAssertEqual(loader.getRequests.count, 1)
        assertURLComponents(
            urlRequest: loader.getRequests[0],
            location: location,
            radius: radius,
            apiKey: endpoint.apiKey
        )
    }
    
    func test_searchNearby_throwsErrorWhenStatusIsNotOK() async {
        let nearbyPlaces = anySearchNearbyResponse(status: .overQueryLimit)
        let (sut, _) = makeSUT(response: nearbyPlaces)
        
        do {
            let nearbyPlaces = try await searchNearby(on: sut)
            XCTFail("Expected to fail, got \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_searchNearby_receiveExpectedSearchNearbyResponse() async throws {
        let expectedResponse = anySearchNearbyResponse()
        let expected = expectedResponse.nearbyPlaces
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await searchNearby(on: sut)
        XCTAssertEqual(expected, receivedResponse)
    }
    
    // MARK: - Helpers
    
    private func searchNearby(on sut: PlacesService, location: Location? = nil, radius: Int? = nil) async throws -> [NearbyPlace] {
        let defaultLocation = Location(latitude: -33.8, longitude: 15.1)
        let defaultRadius = 15
        
        return try await sut.searchNearby(location: location ?? defaultLocation, radius: radius ?? defaultRadius)
    }
    
    private func assertURLComponents(
        urlRequest: URLRequest,
        location: Location,
        radius: Int,
        apiKey: String,
        file: StaticString = #filePath,
        line: UInt = #line
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
            file: file,
            line: line)
    }
    
    private func anySearchNearbyResponse(status: SearchNearbyStatus = .ok) -> SearchNearbyResponse {
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
            ),
        ], status: status)
    }
    
}

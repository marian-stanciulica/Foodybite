//
//  APIServiceTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces
import DomainModels

final class APIServiceTests: XCTestCase {
    
    // MARK: - SearchNearbyService Tests
    
    func test_conformsToSearchNearbyService() {
        let (sut, _) = makeSUT(response: anySearchNearbyResponse())
        XCTAssertNotNil(sut as SearchNearbyService)
    }
    
    func test_searchNearby_searchNearbyParamsUsedToCreateEndpoint() async throws {
        let location = DomainModels.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let (sut, loader) = makeSUT(response: anySearchNearbyResponse())
        let searchNearbyEndpoint = PlacesEndpoint.searchNearby(location: location, radius: radius)
        let urlRequest = try searchNearbyEndpoint.createURLRequest()

        _ = try await sut.searchNearby(location: location, radius: radius)

        let firstRequest = loader.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_searchNearby_usesSearchNearbyEndpointToCreateURLRequest() async throws {
        let location = DomainModels.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let (sut, loader) = makeSUT(response: anySearchNearbyResponse())
        let searchNearbyEndpoint = PlacesEndpoint.searchNearby(location: location, radius: radius)
        let urlRequest = try searchNearbyEndpoint.createURLRequest()

        _ = try await sut.searchNearby(location: location, radius: radius)

        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_searchNearby_receiveExpectedSearchNearbyResponse() async throws {
        let location = DomainModels.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let expectedResponse = anySearchNearbyResponse()
        let expected = expectedResponse.results.map {
            NearbyPlace(
                placeID: $0.placeID,
                placeName: $0.name,
                isOpen: $0.openingHours?.openNow ?? false,
                rating: $0.rating ?? 0,
                location: DomainModels.Location(
                    latitude: $0.geometry.location.lat,
                    longitude: $0.geometry.location.lng
                )
            )
        }
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.searchNearby(location: location, radius: radius)
        XCTAssertEqual(expected, receivedResponse)
    }
    
    // MARK: - GetPlaceDetails Tests
    
    func test_conformsToGetPlaceDetailsService() {
        let (sut, _) = makeSUT(response: anyPlaceDetails())
        XCTAssertNotNil(sut as GetPlaceDetailsService)
    }
    
    func test_getPlaceDetails_getPlaceDetailsParamsUsedToCreateEndpoint() async throws {
        let placeID = randomString()
        
        let (sut, loader) = makeSUT(response: anyPlaceDetails())
        let getPlaceDetailsEndpoint = PlacesEndpoint.getPlaceDetails(placeID: placeID)
        let urlRequest = try getPlaceDetailsEndpoint.createURLRequest()
        
        _ = try await sut.getPlaceDetails(placeID: placeID)
        
        let firstRequest = loader.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_getPlaceDetails_usesGetPlaceDetailsEndpointToCreateURLRequest() async throws {
        let placeID = randomString()

        let (sut, loader) = makeSUT(response: anyPlaceDetails())
        let getPlaceDetailsEndpoint = PlacesEndpoint.getPlaceDetails(placeID: placeID)
        let urlRequest = try getPlaceDetailsEndpoint.createURLRequest()
        
        _ = try await sut.getPlaceDetails(placeID: placeID)
        
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_getPlaceDetails_receiveExpectedPlaceDetailsResponse() async throws {
        let expectedResponse = anyPlaceDetails()
        
        var openingHours: DomainModels.OpeningHoursDetails?
        
        if let hours = expectedResponse.result.openingHours {
            openingHours = DomainModels.OpeningHoursDetails(openNow: hours.openNow, weekdayText: hours.weekdayText)
        }
        
        let expected = PlaceDetails(
            phoneNumber: expectedResponse.result.internationalPhoneNumber,
            name: expectedResponse.result.name,
            address: expectedResponse.result.formattedAddress,
            rating: expectedResponse.result.rating,
            openingHoursDetails: openingHours,
            reviews: expectedResponse.result.reviews.map {
                DomainModels.Review(
                    profileImageURL: $0.profilePhotoURL,
                    authorName: $0.authorName,
                    reviewText: $0.text,
                    rating: $0.rating,
                    relativeTime: $0.relativeTimeDescription
                )
            },
            location: DomainModels.Location(
                latitude: expectedResponse.result.geometry.location.lat,
                longitude: expectedResponse.result.geometry.location.lng
            )
        )
        
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.getPlaceDetails(placeID: randomString())
        
        XCTAssertEqual(expected, receivedResponse)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(response: Decodable) -> (sut: APIService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: response)
        let sut = APIService(loader: loader)
        return (sut, loader)
    }
    
    private func anySearchNearbyResponse() -> SearchNearbyResponse {
        SearchNearbyResponse(results: [
            SearchNearbyResult(
                businessStatus: "",
                geometry: Geometry(
                    location: Location(lat: 0, lng: 0),
                    viewport: Viewport(
                        northeast: Location(lat: 0, lng: 0),
                        southwest: Location(lat: 0, lng: 0))),
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
            )
        ], status: "OK")
    }
    
    private func anyPlaceDetails() -> PlaceDetailsResponse {
        PlaceDetailsResponse(
            result: Details(
                addressComponents: [],
                businessStatus: "",
                formattedAddress: "",
                formattedPhoneNumber: "",
                geometry: Geometry(
                    location: Location(lat: 0, lng: 0),
                    viewport: Viewport(northeast: Location(lat: 0, lng: 0),
                                       southwest: Location(lat: 0, lng: 0))),
                icon: "",
                iconBackgroundColor: "",
                iconMaskBaseURI: "",
                internationalPhoneNumber: "",
                name: "place 1",
                openingHours: OpeningHoursDetails(openNow: false, periods: [], weekdayText: []),
                photos: [],
                placeID: "",
                plusCode: PlusCode(compoundCode: "", globalCode: ""),
                rating: 0,
                reference: "",
                reviews: [],
                types: [],
                url: "",
                userRatingsTotal: 0,
                utcOffset: 0,
                vicinity: "",
                website: ""),
            status: ""
        )
    }
}

//
//  PlacesServiceTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

final class PlacesServiceTests: XCTestCase {
    
    // MARK: - SearchNearbyService Tests
    
    func test_conformsToSearchNearbyService() {
        let (sut, _) = makeSUT(response: anySearchNearbyResponse())
        XCTAssertNotNil(sut as SearchNearbyService)
    }
    
    func test_searchNearby_searchNearbyParamsUsedToCreateEndpoint() async throws {
        let location = Domain.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let (sut, loader) = makeSUT(response: anySearchNearbyResponse())
        let searchNearbyEndpoint = SearchNearbyEndpoint(location: location, radius: radius)
        let urlRequest = try searchNearbyEndpoint.createURLRequest()

        _ = try await sut.searchNearby(location: location, radius: radius)

        let firstRequest = loader.getRequests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_searchNearby_usesSearchNearbyEndpointToCreateURLRequest() async throws {
        let location = Domain.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let (sut, loader) = makeSUT(response: anySearchNearbyResponse())
        let searchNearbyEndpoint = SearchNearbyEndpoint(location: location, radius: radius)
        let urlRequest = try searchNearbyEndpoint.createURLRequest()

        _ = try await sut.searchNearby(location: location, radius: radius)

        XCTAssertEqual(loader.getRequests, [urlRequest])
    }
    
    func test_searchNearby_receiveExpectedSearchNearbyResponse() async throws {
        let location = Domain.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let expectedResponse = anySearchNearbyResponse()
        let expected = expectedResponse.results.map {
            NearbyPlace(
                placeID: $0.placeID,
                placeName: $0.name,
                isOpen: $0.openingHours?.openNow ?? false,
                rating: $0.rating ?? 0,
                location: Domain.Location(
                    latitude: $0.geometry.location.lat,
                    longitude: $0.geometry.location.lng
                ),
                photo: nil
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
        let getPlaceDetailsEndpoint = GetPlaceDetailsEndpoint(placeID: placeID)
        let urlRequest = try getPlaceDetailsEndpoint.createURLRequest()
        
        _ = try await sut.getPlaceDetails(placeID: placeID)
        
        let firstRequest = loader.getRequests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_getPlaceDetails_usesGetPlaceDetailsEndpointToCreateURLRequest() async throws {
        let placeID = randomString()

        let (sut, loader) = makeSUT(response: anyPlaceDetails())
        let getPlaceDetailsEndpoint = GetPlaceDetailsEndpoint(placeID: placeID)
        let urlRequest = try getPlaceDetailsEndpoint.createURLRequest()
        
        _ = try await sut.getPlaceDetails(placeID: placeID)
        
        XCTAssertEqual(loader.getRequests, [urlRequest])
    }
    
    func test_getPlaceDetails_receiveExpectedPlaceDetailsResponse() async throws {
        let expectedResponse = anyPlaceDetails()
        
        var openingHours: Domain.OpeningHoursDetails?
        
        if let hours = expectedResponse.result.openingHours {
            openingHours = Domain.OpeningHoursDetails(openNow: hours.openNow, weekdayText: hours.weekdayText)
        }
        
        let placeID = expectedResponse.result.placeID
        
        let expected = PlaceDetails(
            placeID: placeID,
            phoneNumber: expectedResponse.result.internationalPhoneNumber,
            name: expectedResponse.result.name,
            address: expectedResponse.result.formattedAddress,
            rating: expectedResponse.result.rating,
            openingHoursDetails: openingHours,
            reviews: expectedResponse.result.reviews.map {
                Domain.Review(
                    placeID: placeID,
                    profileImageURL: $0.profilePhotoURL,
                    profileImageData: nil,
                    authorName: $0.authorName,
                    reviewText: $0.text,
                    rating: $0.rating,
                    relativeTime: $0.relativeTimeDescription
                )
            },
            location: Domain.Location(
                latitude: expectedResponse.result.geometry.location.lat,
                longitude: expectedResponse.result.geometry.location.lng
            ),
            photos: []
        )
        
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.getPlaceDetails(placeID: randomString())
        
        XCTAssertEqual(expected, receivedResponse)
    }
    
    // MARK: - FetchPlacePhotoService Tests
    
    func test_conformsToFetchPlacePhotoService() {
        let (sut, _) = makeSUT(response: anyData())
        XCTAssertNotNil(sut as FetchPlacePhotoService)
    }
    
    func test_fetchPlacePhoto_usesParamsToCreateEndpoint() async throws {
        let photoReference = randomString()
        
        let (sut, loader) = makeSUT(response: anyData())
        let getPlacePhotoEndpoint = GetPlacePhotoEndpoint(photoReference: photoReference)
        let urlRequest = try getPlacePhotoEndpoint.createURLRequest()
        
        _ = try await sut.fetchPlacePhoto(photoReference: photoReference)
        
        let firstRequest = loader.getDataRequests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_fetchPlacePhoto_usesGetPlacePhotoEndpointToCreateURLRequest() async throws {
        let photoReference = randomString()

        let (sut, loader) = makeSUT(response: anyData())
        let getPlacePhotoEndpoint = GetPlacePhotoEndpoint(photoReference: photoReference)
        let urlRequest = try getPlacePhotoEndpoint.createURLRequest()
        
        _ = try await sut.fetchPlacePhoto(photoReference: photoReference)
        
        XCTAssertEqual(loader.getDataRequests, [urlRequest])
    }
    
    func test_fetchPlacePhoto_receivesExpectedPlacePhotoResponse() async throws {
        let response = anyData()
        let expectedData = anyData()
        let (sut, loader) = makeSUT(response: response)
        loader.data = expectedData
        
        let receivedResponse = try await sut.fetchPlacePhoto(photoReference: randomString())
        
        XCTAssertEqual(expectedData, receivedResponse)
    }
    
    // MARK: - AutocompletePlacesService
    
    func test_conformsToAutocompletePlacesService() {
        let (sut, _) = makeSUT(response: anyData())
        XCTAssertNotNil(sut as AutocompletePlacesService)
    }
    
    func test_autocomplete_usesAutocompleteEndpointToCreateURLRequest() async throws {
        let input = "input"
        let location = Domain.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let (sut, loader) = makeSUT(response: anyAutocompleteResponse())
        let autocompleteEndpoint = AutocompleteEndpoint(input: input, location: location, radius: radius)
        let urlRequest = try autocompleteEndpoint.createURLRequest()
        
        _ = try await sut.autocomplete(input: input, location: location, radius: radius)
        
        XCTAssertEqual(loader.getRequests, [urlRequest])
    }
    
    func test_autocomplete_receiveExpectedAutocompleteResponse() async throws {
        let input = "input"
        let location = Domain.Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let expectedResponse = anyAutocompleteResponse()
        let expected = expectedResponse.predictions.map {
            AutocompletePrediction(placePrediction: $0.description, placeID: $0.placeID)
        }
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.autocomplete(input: input, location: location, radius: radius)
        XCTAssertEqual(expected, receivedResponse)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(response: Decodable) -> (sut: PlacesService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: response)
        let sut = PlacesService(loader: loader)
        return (sut, loader)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private func anyAutocompleteResponse() -> AutocompleteResponse {
        AutocompleteResponse(
            predictions: [
                Prediction(description: "a description", matchedSubstrings: [], placeID: "place #1", reference: "", structuredFormatting: StructuredFormatting(mainText: "", mainTextMatchedSubstrings: [], secondaryText: ""), terms: [], types: []),
                Prediction(description: "another description", matchedSubstrings: [], placeID: "place #2", reference: "", structuredFormatting: StructuredFormatting(mainText: "", mainTextMatchedSubstrings: [], secondaryText: ""), terms: [], types: [])
            ],
            status: "OK"
        )
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
            status: .ok
        )
    }
}

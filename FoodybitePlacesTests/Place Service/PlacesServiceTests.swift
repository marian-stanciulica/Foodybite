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
        let location = Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let (sut, loader) = makeSUT(response: anySearchNearbyResponse())
        let searchNearbyEndpoint = SearchNearbyEndpoint(location: location, radius: radius)
        let urlRequest = try searchNearbyEndpoint.createURLRequest()

        _ = try await searchNearby(on: sut, location: location, radius: radius)

        let firstRequest = loader.getRequests.first
        let urlComponents = URLComponents(url: firstRequest!.url!, resolvingAgainstBaseURL: true)
        
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: searchNearbyEndpoint.apiKey),
            URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "type", value: "restaurant")
        ]
        
        XCTAssertEqual(urlComponents?.scheme, "https")
        XCTAssertNil(urlComponents?.port)
        XCTAssertEqual(urlComponents?.host, "maps.googleapis.com")
        XCTAssertEqual(urlComponents?.path, "/maps/api/place/nearbysearch/json")
        XCTAssertEqual(urlComponents?.queryItems, expectedQueryItems)
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertNil(urlRequest.httpBody)
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
    
    func test_getPlaceDetails_throwsErrorWhenStatusIsNotOK() async {
        let placeDetails = anyPlaceDetails(status: .notFound)
        let (sut, _) = makeSUT(response: placeDetails)
        
        do {
            let placeDetails = try await sut.getPlaceDetails(placeID: placeDetails.result.placeID)
            XCTFail("Expected to fail, got \(placeDetails) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getPlaceDetails_receiveExpectedPlaceDetailsResponse() async throws {
        let expectedResponse = anyPlaceDetails()
        
        var openingHours: OpeningHoursDetails?
        
        if let hours = expectedResponse.result.openingHours {
            openingHours = OpeningHoursDetails(openNow: hours.openNow, weekdayText: hours.weekdayText)
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
                Review(
                    placeID: placeID,
                    profileImageURL: $0.profilePhotoURL,
                    profileImageData: nil,
                    authorName: $0.authorName,
                    reviewText: $0.text,
                    rating: $0.rating,
                    relativeTime: $0.relativeTimeDescription
                )
            },
            location: Location(
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
        let location = Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let (sut, loader) = makeSUT(response: anyAutocompleteResponse())
        let autocompleteEndpoint = AutocompleteEndpoint(input: input, location: location, radius: radius)
        let urlRequest = try autocompleteEndpoint.createURLRequest()
        
        _ = try await sut.autocomplete(input: input, location: location, radius: radius)
        
        XCTAssertEqual(loader.getRequests, [urlRequest])
    }
    
    func test_autocomplete_throwsErrorWhenStatusIsNotOK() async {
        let input = "input"
        let location = Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        let autocompleteResponse = anyAutocompleteResponse(status: .overQueryLimit)
        let (sut, _) = makeSUT(response: autocompleteResponse)
        
        do {
            let autocompletePredictions = try await sut.autocomplete(input: input, location: location, radius: radius)
            XCTFail("Expected to fail, got \(autocompletePredictions) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_autocomplete_receiveExpectedAutocompleteResponse() async throws {
        let input = "input"
        let location = Location(latitude: -33.8670522, longitude: 151.1957362)
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
    
    private func searchNearby(on sut: PlacesService, location: Location? = nil, radius: Int? = nil) async throws -> [NearbyPlace] {
        let defaultLocation = Location(latitude: -33.8, longitude: 15.1)
        let defaultRadius = 15
        
        return try await sut.searchNearby(location: location ?? defaultLocation, radius: radius ?? defaultRadius)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private func anyAutocompleteResponse(status: AutocompleteStatus = .ok) -> AutocompleteResponse {
        AutocompleteResponse(
            predictions: [
                Prediction(description: "a description", matchedSubstrings: [], placeID: "place #1", reference: "", structuredFormatting: StructuredFormatting(mainText: "", mainTextMatchedSubstrings: [], secondaryText: ""), terms: [], types: []),
                Prediction(description: "another description", matchedSubstrings: [], placeID: "place #2", reference: "", structuredFormatting: StructuredFormatting(mainText: "", mainTextMatchedSubstrings: [], secondaryText: ""), terms: [], types: [])
            ],
            status: status
        )
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
            )
        ], status: status)
    }
    
    private func anyPlaceDetails(status: PlaceDetailsStatus = .ok) -> PlaceDetailsResponse {
        PlaceDetailsResponse(
            result: Details(
                addressComponents: [],
                businessStatus: "",
                formattedAddress: "",
                formattedPhoneNumber: "",
                geometry: Geometry(
                    location: RemoteLocation(lat: 0, lng: 0),
                    viewport: Viewport(northeast: RemoteLocation(lat: 0, lng: 0),
                                       southwest: RemoteLocation(lat: 0, lng: 0))),
                icon: "",
                iconBackgroundColor: "",
                iconMaskBaseURI: "",
                internationalPhoneNumber: "",
                name: "place 1",
                openingHours: RemoteOpeningHoursDetails(openNow: false, periods: [], weekdayText: []),
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
            status: status
        )
    }
}

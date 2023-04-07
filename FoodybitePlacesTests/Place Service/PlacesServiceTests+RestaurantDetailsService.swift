//
//  PlacesServiceTests+RestaurantDetailsService.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

extension PlacesServiceTests {

    func test_conformsToRestaurantDetailsService() {
        let (sut, _) = makeSUT(response: anyRestaurantDetailsResponse())
        XCTAssertNotNil(sut as RestaurantDetailsService)
    }

    func test_getRestaurantDetails_usesGetRestaurantDetailsEndpointToCreateURLRequest() async throws {
        let restaurantID = randomString()
        let (sut, loader) = makeSUT(response: anyRestaurantDetailsResponse())
        let endpoint = GetRestaurantDetailsEndpoint(restaurantID: restaurantID)

        _ = try await sut.getRestaurantDetails(restaurantID: restaurantID)

        XCTAssertEqual(loader.getRequests.count, 1)
        assertURLComponents(
            urlRequest: loader.getRequests[0],
            restaurantID: restaurantID,
            apiKey: endpoint.apiKey
        )
    }

    func test_getRestaurantDetails_throwsErrorWhenStatusIsNotOK() async {
        let failedResponse = anyRestaurantDetailsResponse(status: .notFound)
        let (sut, _) = makeSUT(response: failedResponse)

        do {
            let restaurantDetails = try await sut.getRestaurantDetails(restaurantID: failedResponse.result.placeID)
            XCTFail("Expected to fail, got \(restaurantDetails) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func test_getRestaurantDetails_receiveExpectedRestaurantDetailsResponse() async throws {
        let successfulResponse = anyRestaurantDetailsResponse()
        let (sut, _) = makeSUT(response: successfulResponse)

        let receivedRestaurantDetails = try await sut.getRestaurantDetails(restaurantID: randomString())

        XCTAssertEqual(successfulResponse.restaurantDetails, receivedRestaurantDetails)
    }

    // MARK: - Helpers

    private func assertURLComponents(
        urlRequest: URLRequest,
        restaurantID: String,
        apiKey: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "place_id", value: restaurantID)
        ]

        assertURLComponents(
            urlRequest: urlRequest,
            path: "/maps/api/place/details/json",
            expectedQueryItems: expectedQueryItems,
            file: file,
            line: line)
    }

    private func anyRestaurantDetailsResponse(status: PlaceDetailsStatus = .okStatus) -> PlaceDetailsResponse {
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
                photos: [
                    RemotePhoto(
                        width: 100,
                        height: 100,
                        photoReference: "photo reference"
                    )
                ],
                placeID: "",
                plusCode: PlusCode(compoundCode: "", globalCode: ""),
                rating: 0,
                reference: "",
                reviews: [
                    RemoteReview(
                        authorName: "Author",
                        authorURL: URL(string: "http://any-url.com")!,
                        language: "",
                        profilePhotoURL: nil,
                        rating: 4,
                        relativeTimeDescription: "a year ago",
                        text: "quite nice",
                        time: 3
                    )
                ],
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

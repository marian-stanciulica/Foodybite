//
//  PlacesServiceTests+GetPlaceDetails.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

extension PlacesServiceTests {
    
    func test_conformsToGetPlaceDetailsService() {
        let (sut, _) = makeSUT(response: anyPlaceDetailsResponse())
        XCTAssertNotNil(sut as GetPlaceDetailsService)
    }
    
    func test_getPlaceDetails_usesGetPlaceDetailsEndpointToCreateURLRequest() async throws {
        let placeID = randomString()
        let (sut, loader) = makeSUT(response: anyPlaceDetailsResponse())
        let endpoint = GetPlaceDetailsEndpoint(placeID: placeID)
        
        _ = try await sut.getPlaceDetails(placeID: placeID)
        
        XCTAssertEqual(loader.getRequests.count, 1)
        assertURLComponents(
            urlRequest: loader.getRequests[0],
            placeID: placeID,
            apiKey: endpoint.apiKey
        )
    }
    
    func test_getPlaceDetails_throwsErrorWhenStatusIsNotOK() async {
        let placeDetails = anyPlaceDetailsResponse(status: .notFound)
        let (sut, _) = makeSUT(response: placeDetails)
        
        do {
            let placeDetails = try await sut.getPlaceDetails(placeID: placeDetails.result.placeID)
            XCTFail("Expected to fail, got \(placeDetails) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getPlaceDetails_receiveExpectedPlaceDetailsResponse() async throws {
        let placeDetailsResponse = anyPlaceDetailsResponse()
        let (sut, _) = makeSUT(response: placeDetailsResponse)
        
        let receivedResponse = try await sut.getPlaceDetails(placeID: randomString())
        
        XCTAssertEqual(placeDetailsResponse.placeDetails, receivedResponse)
    }
    
    // MARK: - Helpers
    
    private func assertURLComponents(
        urlRequest: URLRequest,
        placeID: String,
        apiKey: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "place_id", value: placeID)
        ]
        
        assertURLComponents(
            urlRequest: urlRequest,
            path: "/maps/api/place/details/json",
            expectedQueryItems: expectedQueryItems,
            file: file,
            line: line)
    }
    
    private func anyPlaceDetailsResponse(status: PlaceDetailsStatus = .ok) -> PlaceDetailsResponse {
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

//
//  RestaurantReviewCellViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import XCTest
import Domain

class RestaurantReviewCellViewModel: ObservableObject {
    enum State: Equatable {
        case isLoading
        case loadingError(String)
        case requestSucceeeded(PlaceDetails)
    }
    
    private let placeID: String
    private let getPlaceDetailsService: GetPlaceDetailsService
    
    @Published public var getPlaceDetailsState: State = .isLoading
    
    init(placeID: String, getPlaceDetailsService: GetPlaceDetailsService) {
        self.placeID = placeID
        self.getPlaceDetailsService = getPlaceDetailsService
    }
    
    func getPlaceDetails() async {
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
            getPlaceDetailsState = .requestSucceeeded(placeDetails)
        } catch {
            getPlaceDetailsState = .loadingError("An error occured while fetching review details. Please try again later!")
        }
    }
}

final class RestaurantReviewCellViewModelTests: XCTestCase {
    
    func test_init_stateIsLoading() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .isLoading)
    }
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let anyPlaceID = anyPlaceID()
        let (sut, getPlaceDetailsServiceSpy) = makeSUT(placeID: anyPlaceID)
        
        await sut.getPlaceDetails()
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.first, anyPlaceID)
    }
    
    func test_getPlaceDetails_setsStateToLoadingErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, getPlaceDetailsServiceSpy) = makeSUT()
        getPlaceDetailsServiceSpy.result = .failure(anyError())
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .loadingError("An error occured while fetching review details. Please try again later!")])
    }
    
    func test_getPlaceDetails_setsStateToRequestSucceeededWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, getPlaceDetailsServiceSpy) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .requestSucceeeded(expectedPlaceDetails)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeID: String = "") -> (sut: RestaurantReviewCellViewModel,
                               getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy) {
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let sut = RestaurantReviewCellViewModel(placeID: placeID, getPlaceDetailsService: getPlaceDetailsServiceSpy)
        return (sut, getPlaceDetailsServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyPlaceDetails() -> PlaceDetails {
        PlaceDetails(
            phoneNumber: "+61 2 9374 4000",
            name: "Place name",
            address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia",
            rating: rating().raw,
            openingHoursDetails: OpeningHoursDetails(
                openNow: true,
                weekdayText: [
                    "Monday: 9:00 AM – 5:00 PM",
                    "Tuesday: 9:00 AM – 5:00 PM",
                    "Wednesday: 9:00 AM – 5:00 PM",
                    "Thursday: 9:00 AM – 5:00 PM",
                    "Friday: 9:00 AM – 5:00 PM",
                    "Saturday: Closed",
                    "Sunday: Closed",
                ]
            ),
            reviews: [
                Review(
                    profileImageURL: URL(string: "www.google.com"),
                    profileImageData: nil,
                    authorName: "Marian",
                    reviewText: "Loren ipsum...",
                    rating: 2,
                    relativeTime: "5 months ago"
                )
            ],
            location: Location(latitude: 4.4, longitude: 6.9),
            photos: anyPhotos()
        )
    }
    
    private func rating() -> (raw: Double, formatted: String) {
        (4.52, "4.5")
    }
    
    private func anyPhotos() -> [Photo] {
        [
            Photo(width: 100, height: 200, photoReference: "first photo reference"),
            Photo(width: 200, height: 300, photoReference: "second photo reference"),
            Photo(width: 300, height: 400, photoReference: "third photo reference")
        ]
    }
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var capturedValues = [String]()
        var result: Result<PlaceDetails, Error>?
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            capturedValues.append(placeID)
            
            if let result = result {
                return try result.get()
            }
            
            return PlaceDetails(phoneNumber: nil,
                                name: "",
                                address: "",
                                rating: 0,
                                openingHoursDetails: nil,
                                reviews: [],
                                location: Location(latitude: 0, longitude: 0),
                                photos: []
            )
        }
    }
    
}

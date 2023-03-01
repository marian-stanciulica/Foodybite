//
//  NewReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import XCTest
import Domain
import Foodybite

final class NewReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _, _, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .idle)
        XCTAssertEqual(sut.postReviewState, .idle)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertEqual(sut.reviewText, "")
        XCTAssertEqual(sut.starsNumber, 0)
    }
    
    func test_autocomplete_sendsParametersCorrectlyToAutocompletePlacesService() async {
        let anyLocation = anyLocation()
        let radius = 100
        let (sut, autocompleteSpy, _, _) = makeSUT(location: anyLocation)
        sut.searchText = anySearchText()
        
        await sut.autocomplete()
        
        XCTAssertEqual(autocompleteSpy.capturedValues.count, 1)
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.input, anySearchText())
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.location, anyLocation)
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.radius, radius)
    }
    
    func test_autocomplete_setsResultsToEmptyWhenAutocompletePlacesServiceThrowsError() async {
        let (sut, autocompleteSpy, _, _) = makeSUT()
        autocompleteSpy.result = .failure(anyError())
        
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
        
        await sut.autocomplete()
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
    }
    
    func test_autocomplete_setsResultsToReceivedResultsWhenAutocompletePlacesServiceReturnsSuccessfully() async {
        let (sut, autocompleteSpy, _, _) = makeSUT()
        let expectedResults = anyAutocompletePredictions()
        
        autocompleteSpy.result = .success(expectedResults)
        await sut.autocomplete()
        XCTAssertEqual(sut.autocompleteResults, expectedResults)
        
        autocompleteSpy.result = .failure(anyError())
        await sut.autocomplete()
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
    }
    
    func test_autocomplete_resetsStateForPlaceDetails() async {
        let (sut, _, _, _) = makeSUT()
        sut.getPlaceDetailsState = .isLoading

        await sut.autocomplete()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .idle)
    }
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let (sut, _, getPlaceDetailsServiceSpy, _) = makeSUT()
        let anyPlaceID = anyPlaceID()
        
        await sut.getPlaceDetails(placeID: anyPlaceID)
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.first, anyPlaceID)
    }
    
    func test_getPlaceDetails_setsGetPlaceDetailsStateToLoadingErrorWhenGetPlaceDetailsServiceThrowsError() async {
        let (sut, _, getPlaceDetailsServiceSpy, _) = makeSUT()
        getPlaceDetailsServiceSpy.result = .failure(anyError())
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails(placeID: anyPlaceID())
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .failure(.serverError)])
    }
    
    func test_getPlaceDetails_setsGetPlaceDetailsStateToRequestSucceeededWhenGetPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, _, getPlaceDetailsServiceSpy, _) = makeSUT()
        let expectedPlaceDetails = anyPlaceDetails()
        getPlaceDetailsServiceSpy.result = .success(expectedPlaceDetails)
        let stateSpy = PublisherSpy(sut.$getPlaceDetailsState.eraseToAnyPublisher())

        await sut.getPlaceDetails(placeID: anyPlaceID())
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .success(expectedPlaceDetails)])
    }
    
    func test_postReviewEnabled_isTrueWhenPlaceDetailsExistsStarsAreNotZeroAndReviewIsNotEmpty() async {
        let (sut, _, _, _) = makeSUT()
        XCTAssertFalse(sut.postReviewEnabled)
        
        sut.getPlaceDetailsState = .success(anyPlaceDetails())
        XCTAssertFalse(sut.postReviewEnabled)

        sut.starsNumber = 3
        XCTAssertFalse(sut.postReviewEnabled)

        sut.reviewText = anyReviewText()
        XCTAssertTrue(sut.postReviewEnabled)
        
        sut.getPlaceDetailsState = .idle
        XCTAssertFalse(sut.postReviewEnabled)

        sut.getPlaceDetailsState = .success(anyPlaceDetails())
        sut.starsNumber = 0
        XCTAssertFalse(sut.postReviewEnabled)
        
        sut.starsNumber = 3
        sut.reviewText = ""
        XCTAssertFalse(sut.postReviewEnabled)
    }
    
    func test_postReview_isGuardedByPostReviewEnabled() async {
        let (sut, _, _, reviewServiceSpy) = makeSUT()

        await sut.postReview()
        XCTAssertTrue(reviewServiceSpy.capturedValues.isEmpty)
        
        sut.getPlaceDetailsState = .success(anyPlaceDetails())
        await sut.postReview()
        XCTAssertTrue(reviewServiceSpy.capturedValues.isEmpty)
        
        sut.starsNumber = 3
        await sut.postReview()
        XCTAssertTrue(reviewServiceSpy.capturedValues.isEmpty)
        
        sut.reviewText = anyReviewText()
        await sut.postReview()
        XCTAssertFalse(reviewServiceSpy.capturedValues.isEmpty)
    }
    
    func test_postReview_sendsParametersCorrectlyToAddReviewService() async {
        let (sut, _, _, reviewServiceSpy) = makeSUT()
        let anyPlaceDetails = anyPlaceDetails()
        sut.getPlaceDetailsState = .success(anyPlaceDetails)
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()
        
        await sut.postReview()
        
        XCTAssertEqual(reviewServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.placeID, anyPlaceDetails.placeID)
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.reviewText, anyReviewText())
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.starsNumber, anyStarsNumber())
    }
    
    func test_postReview_setsStateToLoadingErrorWhenAddReviewServiceThrowsError() async {
        let (sut, _, _, reviewServiceSpy) = makeSUT()
        sut.getPlaceDetailsState = .success(anyPlaceDetails())
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()
        
        reviewServiceSpy.error = anyError()
        let stateSpy = PublisherSpy(sut.$postReviewState.eraseToAnyPublisher())
        
        await sut.postReview()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .failure(.serverError)])
    }
    
    func test_postReview_setsStateToRequestSucceededWhenAddReviewServiceReturnsSuccess() async {
        let (sut, _, _, _) = makeSUT()
        sut.getPlaceDetailsState = .success(anyPlaceDetails())
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()
        
        let stateSpy = PublisherSpy(sut.$postReviewState.eraseToAnyPublisher())

        await sut.postReview()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .success])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(location: Location? = nil) -> (
        sut: NewReviewViewModel,
        autocompleteSpy: AutocompletePlacesServiceSpy,
        getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy,
        addReviewServiceSpy: AddReviewServiceSpy
    ) {
        let autocompleteSpy = AutocompletePlacesServiceSpy()
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()
        let addReviewServiceSpy = AddReviewServiceSpy()

        let defaultLocation = Location(latitude: 0, longitude: 0)
        let sut = NewReviewViewModel(
            autocompletePlacesService: autocompleteSpy,
            getPlaceDetailsService: getPlaceDetailsServiceSpy,
            addReviewService: addReviewServiceSpy,
            location: location ?? defaultLocation
        )
        return (sut, autocompleteSpy, getPlaceDetailsServiceSpy, addReviewServiceSpy)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyLocation() -> Location {
        Location(latitude: 44.439663, longitude: 26.096306)
    }
    
    private func anySearchText() -> String {
        "any search text"
    }
    
    private func anyReviewText() -> String {
        "any review text"
    }
    
    private func anyStarsNumber() -> Int {
        3
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyAutocompletePredictions() -> [AutocompletePrediction] {
        [
            AutocompletePrediction(placePrediction: "place prediction #1", placeID: "place id #1"),
            AutocompletePrediction(placePrediction: "place prediction #2", placeID: "place id #2"),
            AutocompletePrediction(placePrediction: "place prediction #3", placeID: "place id #3")
        ]
    }
    
    private func anyPlaceDetails() -> PlaceDetails {
        PlaceDetails(
            placeID: "place #1",
            phoneNumber: "+61 2 9374 4000",
            name: "Place name",
            address: "48 Pirrama Rd, Pyrmont NSW 2009, Australia",
            rating: 3.4,
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
                    placeID: "place #1",
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
    
    private func anyPhotos() -> [Photo] {
        [
            Photo(width: 100, height: 200, photoReference: "first photo reference"),
            Photo(width: 200, height: 300, photoReference: "second photo reference"),
            Photo(width: 300, height: 400, photoReference: "third photo reference")
        ]
    }
    
    private class AutocompletePlacesServiceSpy: AutocompletePlacesService {
        private(set) var capturedValues = [(input: String, location: Location, radius: Int)]()
        var result: Result<[AutocompletePrediction], Error>?
        
        func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] {
            capturedValues.append((input, location, radius))
            
            if let result = result {
                return try result.get()
            }
            
            return []
        }
    }
    
    private class GetPlaceDetailsServiceSpy: GetPlaceDetailsService {
        private(set) var capturedValues = [String]()
        var result: Result<PlaceDetails, Error>?
        
        func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
            capturedValues.append(placeID)
            
            if let result = result {
                return try result.get()
            }
            
            return PlaceDetails(placeID: "place #1",
                                phoneNumber: nil,
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
    
    private class AddReviewServiceSpy: AddReviewService {
        private(set) var capturedValues = [(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date)]()
        var error: Error?
        
        func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {
            capturedValues.append((placeID, reviewText, starsNumber, createdAt))
            
            if let error = error {
                throw error
            }
        }
    }
    
}

//
//  NewReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import XCTest
import Domain

final class NewReviewViewModel {
    public enum State: Equatable {
        case idle
        case isLoading
    }
    
    private let autocompletePlacesService: AutocompletePlacesService
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let location: Location
    
    public var getPlaceDetailsState: State = .idle
    public var searchText = ""
    public var reviewText = ""
    public var starsNumber = 0
    public var autocompleteResults = [AutocompletePrediction]()
    
    init(autocompletePlacesService: AutocompletePlacesService, getPlaceDetailsService: GetPlaceDetailsService, location: Location) {
        self.autocompletePlacesService = autocompletePlacesService
        self.getPlaceDetailsService = getPlaceDetailsService
        self.location = location
    }
    
    func autocomplete() async {
        do {
            autocompleteResults = try await autocompletePlacesService.autocomplete(input: searchText, location: location, radius: 100)
        } catch {
            autocompleteResults = []
        }
    }
    
    func getPlaceDetails(placeID: String) async {
        getPlaceDetailsState = .isLoading
        
        _ = try! await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
    }
}

final class NewReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .idle)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertEqual(sut.reviewText, "")
        XCTAssertEqual(sut.starsNumber, 0)
    }
    
    func test_autocomplete_sendsParametersCorrectlyToAutocompletePlacesService() async {
        let anyLocation = anyLocation()
        let radius = 100
        let (sut, autocompleteSpy, _) = makeSUT(location: anyLocation)
        sut.searchText = anySearchText()
        
        await sut.autocomplete()
        
        XCTAssertEqual(autocompleteSpy.capturedValues.count, 1)
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.input, anySearchText())
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.location, anyLocation)
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.radius, radius)
    }
    
    func test_autocomplete_setsResultsToEmptyWhenAutocompletePlacesServiceThrowsError() async {
        let (sut, autocompleteSpy, _) = makeSUT()
        autocompleteSpy.result = .failure(anyError())
        
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
        
        await sut.autocomplete()
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
    }
    
    func test_autocomplete_setsResultsToReceivedResultsWhenAutocompletePlacesServiceReturnsSuccessfully() async {
        let (sut, autocompleteSpy, _) = makeSUT()
        let expectedResults = anyAutocompletePredictions()
        
        autocompleteSpy.result = .success(expectedResults)
        await sut.autocomplete()
        XCTAssertEqual(sut.autocompleteResults, expectedResults)
        
        autocompleteSpy.result = .failure(anyError())
        await sut.autocomplete()
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
    }
    
    func test_getPlaceDetails_setsGetPlaceDetailsStateOnIsLoading() async {
        let (sut, _, _) = makeSUT()

        await sut.getPlaceDetails(placeID: anyPlaceID())
        
        XCTAssertEqual(sut.getPlaceDetailsState, .isLoading)
    }
    
    func test_getPlaceDetails_sendsInputsToGetPlaceDetailsService() async {
        let (sut, _, getPlaceDetailsServiceSpy) = makeSUT()
        let anyPlaceID = anyPlaceID()
        
        await sut.getPlaceDetails(placeID: anyPlaceID)
        
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(getPlaceDetailsServiceSpy.capturedValues.first, anyPlaceID)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(location: Location? = nil) -> (sut: NewReviewViewModel, autocompleteSpy: AutocompletePlacesServiceSpy, getPlaceDetailsServiceSpy: GetPlaceDetailsServiceSpy) {
        let autocompleteSpy = AutocompletePlacesServiceSpy()
        let getPlaceDetailsServiceSpy = GetPlaceDetailsServiceSpy()

        let defaultLocation = Location(latitude: 0, longitude: 0)
        let sut = NewReviewViewModel(
            autocompletePlacesService: autocompleteSpy,
            getPlaceDetailsService: getPlaceDetailsServiceSpy,
            location: location ?? defaultLocation
        )
        return (sut, autocompleteSpy, getPlaceDetailsServiceSpy)
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
    
}

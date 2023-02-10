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
    private let location: Location
    
    public var getPlaceDetailsState: State = .idle
    public var searchText = ""
    public var reviewText = ""
    public var starsNumber = 0
    public var autocompleteResults = [AutocompletePrediction]()
    
    init(autocompletePlacesService: AutocompletePlacesService, location: Location) {
        self.autocompletePlacesService = autocompletePlacesService
        self.location = location
    }
    
    func autocomplete() async {
        do {
            autocompleteResults = try await autocompletePlacesService.autocomplete(input: searchText, location: location, radius: 100)
        } catch {
            autocompleteResults = []
        }
    }
    
    func getPlaceDetails() {
        getPlaceDetailsState = .isLoading
    }
}

final class NewReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .idle)
        XCTAssertEqual(sut.searchText, "")
        XCTAssertEqual(sut.reviewText, "")
        XCTAssertEqual(sut.starsNumber, 0)
    }
    
    func test_autocomplete_sendsParametersCorrectlyToAutocompletePlacesService() async {
        let anyLocation = anyLocation()
        let radius = 100
        let (sut, autocompleteSpy) = makeSUT(location: anyLocation)
        sut.searchText = anySearchText()
        
        await sut.autocomplete()
        
        XCTAssertEqual(autocompleteSpy.capturedValues.count, 1)
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.input, anySearchText())
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.location, anyLocation)
        XCTAssertEqual(autocompleteSpy.capturedValues.first?.radius, radius)
    }
    
    func test_autocomplete_setsResultsToEmptyWhenAutocompletePlacesServiceThrowsError() async {
        let (sut, autocompleteSpy) = makeSUT()
        autocompleteSpy.result = .failure(anyError())
        
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
        
        await sut.autocomplete()
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
    }
    
    func test_autocomplete_setsResultsToReceivedResultsWhenAutocompletePlacesServiceReturnsSuccessfully() async {
        let (sut, autocompleteSpy) = makeSUT()
        let expectedResults = anyAutocompletePredictions()
        
        autocompleteSpy.result = .success(expectedResults)
        await sut.autocomplete()
        XCTAssertEqual(sut.autocompleteResults, expectedResults)
        
        autocompleteSpy.result = .failure(anyError())
        await sut.autocomplete()
        XCTAssertTrue(sut.autocompleteResults.isEmpty)
    }
    
    func test_getPlaceDetails_setsGetPlaceDetailsStateOnIsLoading() async {
        let (sut, _) = makeSUT()

        sut.getPlaceDetails()
        
        XCTAssertEqual(sut.getPlaceDetailsState, .isLoading)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(location: Location? = nil) -> (sut: NewReviewViewModel, autocompleteSpy: AutocompletePlacesServiceSpy) {
        let autocompleteSpy = AutocompletePlacesServiceSpy()
        let defaultLocation = Location(latitude: 0, longitude: 0)
        let sut = NewReviewViewModel(autocompletePlacesService: autocompleteSpy, location: location ?? defaultLocation)
        return (sut, autocompleteSpy)
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
    
}

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
    }
    
    private let autocompletePlacesService: AutocompletePlacesService
    private let location: Location
    
    public var state: State = .idle
    public var searchText = ""
    public var reviewText = ""
    public var starsNumber = 0
    
    init(autocompletePlacesService: AutocompletePlacesService, location: Location) {
        self.autocompletePlacesService = autocompletePlacesService
        self.location = location
    }
    
    func autocomplete() async {
        _ = try? await autocompletePlacesService.autocomplete(input: searchText, location: location, radius: 100)
    }
}

final class NewReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.state, .idle)
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
    
    private class AutocompletePlacesServiceSpy: AutocompletePlacesService {
        private(set) var capturedValues = [(input: String, location: Location, radius: Int)]()
        
        func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] {
            capturedValues.append((input, location, radius))
            return []
        }
    }
    
}

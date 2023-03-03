//
//  SearchFilteringViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
import Domain

final class SearchFilteringViewModel {
    private let userPreferencesSaver: UserPreferencesSaver
    
    var radius: Int
    var starsNumber: Int
    
    init(userPreferences: UserPreferences, userPreferencesSaver: UserPreferencesSaver) {
        self.userPreferencesSaver = userPreferencesSaver
        
        radius = userPreferences.radius
        starsNumber = userPreferences.starsNumber
    }
    
    func apply() {
        userPreferencesSaver.save(UserPreferences(radius: radius, starsNumber: starsNumber))
    }
}

final class SearchFilteringViewModelTests: XCTestCase {

    func test_init_setsRadiusAndStarsNumberByLoadingUserPreferences() {
        let radius = 123
        let starsNumber = 3
        let (sut, _) = makeSUT(stub: UserPreferences(radius: radius, starsNumber: starsNumber))
        
        XCTAssertEqual(sut.radius, radius)
        XCTAssertEqual(sut.starsNumber, starsNumber)
    }
    
    func test_apply_savesUserPreferencesUsingUserPreferencesSaver() {
        let radius = 123
        let starsNumber = 3
        let (sut, userPreferencesSaverSpy) = makeSUT(stub: .default)
        sut.radius = radius
        sut.starsNumber = starsNumber
        
        sut.apply()
        
        XCTAssertEqual(userPreferencesSaverSpy.capturedValues, [UserPreferences(radius: radius, starsNumber: starsNumber)])
    }

    // MARK: - Helpers
    
    private func makeSUT(stub: UserPreferences) -> (sut: SearchFilteringViewModel, userPreferencesSaverSpy: UserPreferencesSaverSpy) {
        let userPreferencesSaverSpy = UserPreferencesSaverSpy()
        let sut = SearchFilteringViewModel(userPreferences: stub, userPreferencesSaver: userPreferencesSaverSpy)
        return (sut, userPreferencesSaverSpy)
    }
    
    private class UserPreferencesSaverSpy: UserPreferencesSaver {
        private(set) var capturedValues = [UserPreferences]()
        
        func save(_ userPreferences: UserPreferences) {
            capturedValues.append(userPreferences)
        }
    }
}

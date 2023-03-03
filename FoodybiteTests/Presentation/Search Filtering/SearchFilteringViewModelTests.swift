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
    
    func reset() {
        userPreferencesSaver.save(.default)
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
        let expectedUserPreferences = UserPreferences(radius: 123, starsNumber: 3)
        let (sut, userPreferencesSaverSpy) = makeSUT(stub: expectedUserPreferences)
        
        sut.apply()
        
        XCTAssertEqual(userPreferencesSaverSpy.capturedValues, [expectedUserPreferences])
    }
    
    func test_reset_savesDefaultUserPreferences() {
        let (sut, userPreferencesSaverSpy) = makeSUT(stub: UserPreferences(radius: 123, starsNumber: 3))
        
        sut.reset()
        
        XCTAssertEqual(userPreferencesSaverSpy.capturedValues, [.default])
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

//
//  SearchFilteringViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
import Domain

final class SearchFilteringViewModel {
    private let userPreferencesLoader: UserPreferencesLoader
    private let userPreferencesSaver: UserPreferencesSaver
    
    var radius: Int = 0
    var starsNumber: Int = 0
    
    init(userPreferencesLoader: UserPreferencesLoader, userPreferencesSaver: UserPreferencesSaver) {
        self.userPreferencesLoader = userPreferencesLoader
        self.userPreferencesSaver = userPreferencesSaver
    }
    
    var userPreferences: UserPreferences {
        userPreferencesLoader.load()
    }
    
    func apply() {
        userPreferencesSaver.save(UserPreferences(radius: radius, starsNumber: starsNumber))
    }
}

final class SearchFilteringViewModelTests: XCTestCase {

    func test_userPreferences_retrievedSuccessfullyByLoader() {
        let expectedUserPreferences = UserPreferences(radius: 123, starsNumber: 3)
        let (sut, _) = makeSUT(stub: expectedUserPreferences)
        
        XCTAssertEqual(sut.userPreferences, expectedUserPreferences)
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
        let userPreferencesLoaderStub = UserPreferencesLoaderStub(stub: stub)
        let userPreferencesSaverSpy = UserPreferencesSaverSpy()
        let sut = SearchFilteringViewModel(userPreferencesLoader: userPreferencesLoaderStub, userPreferencesSaver: userPreferencesSaverSpy)
        return (sut, userPreferencesSaverSpy)
    }
    
    private class UserPreferencesLoaderStub: UserPreferencesLoader {
        private let stub: UserPreferences
        
        init(stub: UserPreferences) {
            self.stub = stub
        }
        
        func load() -> UserPreferences {
            return stub
        }
    }
    
    private class UserPreferencesSaverSpy: UserPreferencesSaver {
        private(set) var capturedValues = [UserPreferences]()
        
        func save(_ userPreferences: UserPreferences) {
            capturedValues.append(userPreferences)
        }
    }
}

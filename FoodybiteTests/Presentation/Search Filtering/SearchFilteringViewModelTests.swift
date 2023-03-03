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
    
    init(userPreferencesLoader: UserPreferencesLoader) {
        self.userPreferencesLoader = userPreferencesLoader
    }
    
    var userPreferences: UserPreferences {
        userPreferencesLoader.load()
    }
}

final class SearchFilteringViewModelTests: XCTestCase {

    func test_userPreferences_retrievedSuccessfullyByLoader() {
        let expectedUserPreferences = UserPreferences(radius: 123, starsNumber: 3)
        let sut = makeSUT(stub: expectedUserPreferences)
        
        XCTAssertEqual(sut.userPreferences, expectedUserPreferences)
    }

    // MARK: - Helpers
    
    private func makeSUT(stub: UserPreferences) -> SearchFilteringViewModel {
        let userPreferencesLoaderStub = UserPreferencesLoaderStub(stub: stub)
        let sut = SearchFilteringViewModel(userPreferencesLoader: userPreferencesLoaderStub)
        return sut
    }
    
    final class UserPreferencesLoaderStub: UserPreferencesLoader {
        private let stub: UserPreferences
        
        init(stub: UserPreferences) {
            self.stub = stub
        }
        
        func load() -> UserPreferences {
            return stub
        }
    }
}

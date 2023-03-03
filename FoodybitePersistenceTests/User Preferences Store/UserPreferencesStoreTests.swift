//
//  UserPreferencesStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
import Domain

final class UserPreferencesStore {
    
    
    func load() -> UserPreferences {
        .default
    }
}

final class UserPreferencesStoreTests: XCTestCase {

    func test_load_returnsDefaultUserPreferencesWhenEmptyStore() {
        let sut = UserPreferencesStore()
        
        let receivedUserPrefences = sut.load()
        
        XCTAssertEqual(receivedUserPrefences, .default)
    }

}

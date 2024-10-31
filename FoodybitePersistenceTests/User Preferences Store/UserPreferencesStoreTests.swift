//
//  UserPreferencesStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Testing
import Foundation.NSData
import FoodybitePersistence
import Domain

@Suite(.serialized)
final class UserPreferencesLocalStoreTests {

    deinit {
        _ = makeEmptyUserDefaults()
    }

    @Test func load_returnsDefaultUserPreferencesWhenEmptyStore() {
        let (sut, _) = makeSUT()

        let receivedUserPrefences = sut.load()

        #expect(receivedUserPrefences == .default)
    }

    @Test func load_returnsDefaultUserPreferencesWhenDecodingFailed() {
        let (sut, userDefaults) = makeSUT()
        userDefaults.set(Data(), forKey: UserPreferencesLocalStore.Keys.userPreferences.rawValue)

        let receivedUserPrefences = sut.load()

        #expect(receivedUserPrefences == .default)
    }

    @Test func load_loadsStoredUserPreferences() {
        let (sut, _) = makeSUT()
        let expectedUserPreferences = UserPreferences(radius: 123, starsNumber: 3)
        sut.save(expectedUserPreferences)

        let receivedUserPrefences = sut.load()

        #expect(receivedUserPrefences == expectedUserPreferences)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: UserPreferencesLocalStore, userDefaults: UserDefaults) {
        let userDefaults = makeEmptyUserDefaults()
        let sut = UserPreferencesLocalStore(userDefaults: userDefaults)
        return (sut, userDefaults)
    }

    private func makeEmptyUserDefaults() -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: #filePath)!
        userDefaults.removePersistentDomain(forName: #filePath)
        return userDefaults
    }
}

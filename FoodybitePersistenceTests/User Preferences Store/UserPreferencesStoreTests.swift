//
//  UserPreferencesStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
import Domain

struct LocalUserPreferences: Codable {
    let radius: Int
    let starsNumber: Int
    
    func toDomain() -> UserPreferences {
        UserPreferences(radius: radius, starsNumber: starsNumber)
    }
}

extension UserPreferences {
    func toLocal() -> LocalUserPreferences {
        LocalUserPreferences(radius: radius, starsNumber: starsNumber)
    }
}

final class UserPreferencesLocalStore {
    enum Keys: String {
        case userPreferences
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func load() -> UserPreferences {
        guard let preferencesData = userDefaults.data(forKey: Keys.userPreferences.rawValue) else { return .default }
        guard let preferences = try? JSONDecoder().decode(LocalUserPreferences.self, from: preferencesData) else { return .default }
        return preferences.toDomain()
    }
    
    func save(_ userPreferences: UserPreferences) {
        guard let preferencesData = try? JSONEncoder().encode(userPreferences.toLocal()) else { return }
        userDefaults.set(preferencesData, forKey: Keys.userPreferences.rawValue)
    }
}

final class UserPreferencesLocalStoreTests: XCTestCase {

    override func tearDown() {
        _ = makeEmptyUserDefaults()
    }
    
    func test_load_returnsDefaultUserPreferencesWhenEmptyStore() {
        let sut = makeSUT()
        
        let receivedUserPrefences = sut.load()
        
        XCTAssertEqual(receivedUserPrefences, .default)
    }
    
    func test_load_loadsStoredUserPreferences() {
        let sut = makeSUT()
        let expectedUserPreferences = UserPreferences(radius: 123, starsNumber: 3)
        sut.save(expectedUserPreferences)
        
        let receivedUserPrefences = sut.load()
        
        XCTAssertEqual(receivedUserPrefences, expectedUserPreferences)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> UserPreferencesLocalStore {
        let userDefaults = makeEmptyUserDefaults()
        return UserPreferencesLocalStore(userDefaults: userDefaults)
    }
    
    private func makeEmptyUserDefaults() -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: #filePath)!
        userDefaults.removePersistentDomain(forName: #filePath)
        return userDefaults
    }
}

//
//  UserPreferencesLocalStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import Domain

public final class UserPreferencesLocalStore: UserPreferencesSaver, UserPreferencesLoader {
    public enum Keys: String {
        case userPreferences
    }
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func load() -> UserPreferences {
        guard let preferencesData = userDefaults.data(forKey: Keys.userPreferences.rawValue) else { return .default }
        guard let preferences = try? JSONDecoder().decode(LocalUserPreferences.self, from: preferencesData) else { return .default }
        return preferences.toDomain()
    }
    
    public func save(_ userPreferences: UserPreferences) {
        guard let preferencesData = try? JSONEncoder().encode(userPreferences.toLocal()) else { return }
        userDefaults.set(preferencesData, forKey: Keys.userPreferences.rawValue)
    }
}

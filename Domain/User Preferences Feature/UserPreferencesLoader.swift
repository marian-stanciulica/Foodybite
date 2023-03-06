//
//  UserPreferencesLoader.swift
//  Domain
//
//  Created by Marian Stanciulica on 03.03.2023.
//

public protocol UserPreferencesLoader {
    func load() -> UserPreferences
}

//
//  SearchFilteringViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Domain

public final class SearchFilteringViewModel {
    private let userPreferencesSaver: UserPreferencesSaver
    
    public var radius: Int
    public var starsNumber: Int
    
    public init(userPreferences: UserPreferences, userPreferencesSaver: UserPreferencesSaver) {
        self.userPreferencesSaver = userPreferencesSaver
        
        radius = userPreferences.radius
        starsNumber = userPreferences.starsNumber
    }
    
    public func apply() {
        userPreferencesSaver.save(UserPreferences(radius: radius, starsNumber: starsNumber))
    }
    
    public func reset() {
        userPreferencesSaver.save(.default)
    }
}

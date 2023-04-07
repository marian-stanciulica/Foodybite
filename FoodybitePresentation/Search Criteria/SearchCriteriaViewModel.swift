//
//  SearchCriteriaViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import Domain

public final class SearchCriteriaViewModel: ObservableObject {
    private let userPreferencesSaver: UserPreferencesSaver

    @Published public var radius: Int
    @Published public var starsNumber: Int

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

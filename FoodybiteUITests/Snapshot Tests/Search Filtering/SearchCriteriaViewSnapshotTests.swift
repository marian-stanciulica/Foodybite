//
//  SearchCriteriaViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.02.2023.
//

import CoreFoundation
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

struct SearchCriteriaViewSnapshotTests {

    func test_searchCriteriaView() {
        let sut = makeSUT(radius: 20, starsNumber: 4)

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(radius: CGFloat, starsNumber: Int) -> SearchCriteriaView {
        let viewModel = SearchCriteriaViewModel(
            userPreferences: makeUserPreferences(),
            userPreferencesSaver: EmptyUserPreferencesSaver()
        )
        return SearchCriteriaView(viewModel: viewModel)
    }

    private func makeUserPreferences() -> UserPreferences {
        UserPreferences(radius: 10_000, starsNumber: 4)
    }

    private class EmptyUserPreferencesSaver: UserPreferencesSaver {
        func save(_ userPreferences: UserPreferences) {}
    }
}

//
//  SearchCriteriaViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.02.2023.
//

import XCTest
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

final class SearchCriteriaViewSnapshotTests: XCTestCase {

    func test_searchCriteriaView() {
        let sut = makeSUT(radius: 20, starsNumber: 4)

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
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

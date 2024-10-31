//
//  TabBarPageViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 04.04.2023.
//

import Testing
import SnapshotTesting
import SwiftUI
@testable import Foodybite

struct TabBarPageViewSnapshotTests {

    @MainActor @Test func tabBarPageViewWithFocusOnHomeTab() {
        let sut = makeSUT(page: .home)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func tabBarPageViewWithFocusOnNewReviewTab() {
        let sut = makeSUT(page: .newReview, plusButtonActive: true)

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(page: TabRouter.Page, plusButtonActive: Bool = false) -> TabBarPageView<EmptyView> {
        TabBarPageView(page: .constant(page), plusButtonActive: plusButtonActive) {
            EmptyView()
        }
    }

}

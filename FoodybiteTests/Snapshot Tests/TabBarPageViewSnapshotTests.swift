//
//  TabBarPageViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 04.04.2023.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import Foodybite

final class TabBarPageViewSnapshotTests: XCTestCase {

    func test_tabBarPageViewWithFocusOnHomeTab() {
        let sut = makeSUT(page: .home)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_tabBarPageViewWithFocusOnNewReviewTab() {
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

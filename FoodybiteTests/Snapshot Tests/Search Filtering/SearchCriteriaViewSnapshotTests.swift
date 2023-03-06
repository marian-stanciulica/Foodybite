//
//  SearchCriteriaViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class SearchCriteriaViewSnapshotTests: XCTestCase {
    
    func test_searchCriteriaView() {
        let sut = makeSUT(radius: 20, starsNumber: 4)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(radius: CGFloat, starsNumber: Int) -> UIViewController {
        let viewModel = SearchCriteriaViewModel(
            userPreferences: makeUserPreferences(),
            userPreferencesSaver: EmptyUserPreferencesSaver()
        )
        let registerView = SearchCriteriaView(viewModel: viewModel)
        let sut = UIHostingController(rootView: registerView)
        return sut
    }
    
    private func makeUserPreferences() -> UserPreferences {
        UserPreferences(radius: 200, starsNumber: 4)
    }
    
    private class EmptyUserPreferencesSaver: UserPreferencesSaver {
        func save(_ userPreferences: UserPreferences) {}
    }
}
 

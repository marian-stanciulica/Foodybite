//
//  SearchCriteriaViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Testing
import Domain
import FoodybitePresentation

struct SearchCriteriaViewModelTests {

    @Test func init_setsRadiusAndStarsNumberByLoadingUserPreferences() {
        let radius = 123
        let starsNumber = 3
        let (sut, _) = makeSUT(stub: UserPreferences(radius: radius, starsNumber: starsNumber))

        #expect(sut.radius == radius)
        #expect(sut.starsNumber == starsNumber)
    }

    @Test func apply_savesUserPreferencesUsingUserPreferencesSaver() {
        let expectedUserPreferences = UserPreferences(radius: 123, starsNumber: 3)
        let (sut, userPreferencesSaverSpy) = makeSUT(stub: expectedUserPreferences)

        sut.apply()

        #expect(userPreferencesSaverSpy.capturedValues == [expectedUserPreferences])
    }

    @Test func reset_savesDefaultUserPreferences() {
        let (sut, userPreferencesSaverSpy) = makeSUT(stub: UserPreferences(radius: 123, starsNumber: 3))

        sut.reset()

        #expect(userPreferencesSaverSpy.capturedValues == [.default])
    }

    // MARK: - Helpers

    private func makeSUT(stub: UserPreferences) -> (sut: SearchCriteriaViewModel, userPreferencesSaverSpy: UserPreferencesSaverSpy) {
        let userPreferencesSaverSpy = UserPreferencesSaverSpy()
        let sut = SearchCriteriaViewModel(userPreferences: stub, userPreferencesSaver: userPreferencesSaverSpy)
        return (sut, userPreferencesSaverSpy)
    }

    private class UserPreferencesSaverSpy: UserPreferencesSaver {
        private(set) var capturedValues = [UserPreferences]()

        func save(_ userPreferences: UserPreferences) {
            capturedValues.append(userPreferences)
        }
    }
}

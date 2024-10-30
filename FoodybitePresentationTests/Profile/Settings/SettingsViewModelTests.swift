//
//  SettingsViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Testing
import Foundation.NSError
import Domain
import FoodybitePresentation

struct SettingsViewModelTests {

    @Test func logout_callsGoToLoginWhenLogoutServiceThrowsError() async {
        var goToLoginCalled = false
        let (sut, logoutServiceSpy) = makeSUT {
            goToLoginCalled = true
        }

        let expectedError = anyNSError()
        logoutServiceSpy.errorToThrow = expectedError

        await sut.logout()

        #expect(goToLoginCalled)
    }

    @Test func logout_callsGoToLoginWhenLogoutServiceFinishedSuccessfully() async {
        var goToLoginCalled = false
        let (sut, _) = makeSUT {
            goToLoginCalled = true
        }

        await sut.logout()

        #expect(goToLoginCalled)
    }

    // MARK: - Helpers

    private func makeSUT(goToLogin: @escaping () -> Void = {}) -> (sut: SettingsViewModel, logoutService: LogoutServiceSpy) {
        let logoutServiceSpy = LogoutServiceSpy()
        let sut = SettingsViewModel(logoutService: logoutServiceSpy, goToLogin: goToLogin)
        return (sut, logoutServiceSpy)
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }

    private class LogoutServiceSpy: LogoutService {
        var errorToThrow: Error?
        private(set) var logoutCalledCount = 0

        func logout() async throws {
            logoutCalledCount += 1

            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
        }
    }
}

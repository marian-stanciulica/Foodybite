//
//  SettingsViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import XCTest
import Foodybite
import FoodybiteNetworking

final class SettingsViewModelTests: XCTestCase {

    func test_logout_throwsErrorWhenLogoutServiceThrowsError() async {
        let (sut, logoutServiceSpy) = makeSUT()
        
        let expectedError = anyNSError()
        logoutServiceSpy.errorToThrow = expectedError
        
        await sut.logout()
        
        XCTAssertEqual(sut.error, .serverError)
    }
    
    func test_logout_callsGoToLoginWhenLogoutServiceFinishedSuccessfully() async {
        var goToLoginCalled = false
        let (sut, _) = makeSUT() {
            goToLoginCalled = true
        }
        
        await sut.logout()
        
        XCTAssertTrue(goToLoginCalled)
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

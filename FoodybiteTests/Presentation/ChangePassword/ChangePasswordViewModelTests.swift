//
//  ChangePasswordViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import XCTest
import Foodybite

final class ChangePasswordViewModelTests: XCTestCase {

    func test_changePassword_triggerEmptyPasswordErrorOnEmptyCurrentPassword() async {
        let sut = makeSUT()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.empty))
    }
    
    func test_changePassword_triggerTooShortPasswordErrorOnTooShortNewPassword() async {
        let sut = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = shortPassword()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.tooShortPassword))
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> ChangePasswordViewModel {
        let sut = ChangePasswordViewModel()
        return sut
    }
    
    private func nonEmptyPassword() -> String {
        "non empty"
    }
    
    private func shortPassword() -> String {
        "Aa1%"
    }
    
    private func assertRegister(on sut: ChangePasswordViewModel,
                                withExpectedResult expectedResult: ChangePasswordViewModel.Result,
                                file: StaticString = #file,
                                line: UInt = #line) async {
        let registerResultSpy = PublisherSpy(sut.$result.eraseToAnyPublisher())

        XCTAssertEqual(registerResultSpy.results, [.notTriggered], file: file, line: line)
        
        await sut.changePassword()
        
        XCTAssertEqual(registerResultSpy.results, [.notTriggered, expectedResult], file: file, line: line)
        registerResultSpy.cancel()
    }

}

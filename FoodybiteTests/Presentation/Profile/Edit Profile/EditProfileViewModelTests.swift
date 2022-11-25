//
//  EditProfileViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import XCTest
import Foodybite

final class EditProfileViewModelTests: XCTestCase {

    func test_updateAccount_triggerEmptyNameErrorOnEmptyNameTextField() async {
        let sut = makeSUT()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.emptyName))
    }
    
    func test_updateAccount_triggerEmptyEmailErrorOnEmptyEmailTextField() async {
        let sut = makeSUT()
        sut.name = validName()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.emptyEmail))
    }
    
    func test_updateAccount_triggerInvalidFormatErrorOnInvalidEmail() async {
        let sut = makeSUT()
        sut.name = validName()
        sut.email = invalidEmail()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.invalidEmail))
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> EditProfileViewModel {
        return EditProfileViewModel()
    }
    
    private func assertRegister(on sut: EditProfileViewModel,
                                withExpectedResult expectedResult: EditProfileViewModel.Result,
                                file: StaticString = #file,
                                line: UInt = #line) async {
        let resultSpy = PublisherSpy(sut.$result.eraseToAnyPublisher())

        XCTAssertEqual(resultSpy.results, [.notTriggered], file: file, line: line)
        
        await sut.updateAccount()
        
        XCTAssertEqual(resultSpy.results, [.notTriggered, expectedResult], file: file, line: line)
        resultSpy.cancel()
    }
    
    private func validName() -> String {
        "any name"
    }
    
    private func invalidEmail() -> String {
        "invalid email"
    }

}

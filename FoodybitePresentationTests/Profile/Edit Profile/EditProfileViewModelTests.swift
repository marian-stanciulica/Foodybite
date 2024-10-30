//
//  EditProfileViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Testing
import Foundation.NSData
import Domain
import FoodybitePresentation

struct EditProfileViewModelTests {

    @Test func isLoading_isTrueOnlyWhenResultIsLoading() {
        let (sut, _) = makeSUT()

        sut.state = .idle
        #expect(!sut.isLoading)

        sut.state = .isLoading
        #expect(sut.isLoading)

        sut.state = .failure(.serverError)
        #expect(!sut.isLoading)

        sut.state = .success
        #expect(!sut.isLoading)
    }

    @Test func updateAccount_triggerEmptyNameErrorOnEmptyNameTextField() async {
        let (sut, _) = makeSUT()

        await assertRegister(on: sut, withExpectedResult: .failure(.emptyName))
    }

    @Test func updateAccount_triggerEmptyEmailErrorOnEmptyEmailTextField() async {
        let (sut, _) = makeSUT()
        sut.name = validName()

        await assertRegister(on: sut, withExpectedResult: .failure(.emptyEmail))
    }

    @Test func updateAccount_triggerInvalidFormatErrorOnInvalidEmail() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = invalidEmail()

        await assertRegister(on: sut, withExpectedResult: .failure(.invalidEmail))
    }

    @Test func updateAccount_sendsValidInputsToAccountService() async {
        let (sut, accountServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()

        await sut.updateAccount()

        #expect(accountServiceSpy.capturedValues.map(\.name) == [validName()])
        #expect(accountServiceSpy.capturedValues.map(\.email) == [validEmail()])

        await sut.updateAccount()

        #expect(accountServiceSpy.capturedValues.map(\.name) == [validName(), validName()])
        #expect(accountServiceSpy.capturedValues.map(\.email) == [validEmail(), validEmail()])
    }

    @Test func updateAccount_throwsErrorWhenAccountServiceThrowsError() async {
        let (sut, signUpServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()

        let expectedError = anyNSError()
        signUpServiceSpy.errorToThrow = expectedError

        await assertRegister(on: sut, withExpectedResult: .failure(.serverError))
    }

    @Test func updateAccount_setsSuccessfulResultWhenAccountServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()

        await assertRegister(on: sut, withExpectedResult: .success)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: EditProfileViewModel, accountServiceSpy: AccountServiceSpy) {
        let accountServiceSpy = AccountServiceSpy()
        let sut = EditProfileViewModel(accountService: accountServiceSpy)
        return (sut, accountServiceSpy)
    }

    private func assertRegister(on sut: EditProfileViewModel,
                                withExpectedResult expectedResult: EditProfileViewModel.State,
                                sourceLocation: SourceLocation = #_sourceLocation) async {
        let resultSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())

        #expect(resultSpy.results == [.idle], sourceLocation: sourceLocation)

        await sut.updateAccount()

        #expect(resultSpy.results == [.idle, .isLoading, expectedResult], sourceLocation: sourceLocation)
        resultSpy.cancel()
    }

    private func validName() -> String {
        "any name"
    }

    private func invalidEmail() -> String {
        "invalid email"
    }

    private func validEmail() -> String {
        "test@test.com"
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }

    private class AccountServiceSpy: AccountService {
        struct UpdateAccountParams {
            let name: String
            let email: String
            let profileImage: Data?
        }

        var errorToThrow: Error?
        private(set) var capturedValues = [UpdateAccountParams]()

        func updateAccount(name: String, email: String, profileImage: Data?) async throws {
            capturedValues.append(UpdateAccountParams(name: name, email: email, profileImage: profileImage))

            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
        }

        func deleteAccount() async throws {

        }
    }

}

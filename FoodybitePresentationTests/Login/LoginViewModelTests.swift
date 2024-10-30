//
//  LoginViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Testing
import Foundation.NSError
import Domain
import FoodybitePresentation

struct LoginViewModelTests {

    @Test func loginError_rawValueOfServerError() {
        #expect(LoginViewModel.LoginError.serverError.rawValue == "Invalid Credentials")
    }

    @Test func state_initiallyIdle() {
        let (sut, _) = makeSUT()

        #expect(sut.state == .idle)
    }

    @Test func isLoading_isTrueOnlyWhenRegisterResultIsLoading() {
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

    @Test func login_sendsInputsToLoginService() async {
        let (sut, loginServiceSpy) = makeSUT()
        sut.email = anyEmail()
        sut.password = anyPassword()

        await sut.login()

        #expect(loginServiceSpy.capturedValues.map(\.email) == [anyEmail()])
        #expect(loginServiceSpy.capturedValues.map(\.password) == [anyPassword()])

        await sut.login()

        #expect(loginServiceSpy.capturedValues.map(\.email) == [anyEmail(), anyEmail()])
        #expect(loginServiceSpy.capturedValues.map(\.password) == [anyPassword(), anyPassword()])
    }

    @Test func login_throwsErrorWhenLoginServiceThrowsError() async {
        let (sut, loginServiceSpy) = makeSUT()
        sut.email = anyEmail()
        sut.password = anyPassword()

        let expectedError = anyNSError()
        loginServiceSpy.errorToThrow = expectedError

        await sut.login()
        #expect(sut.state == .failure(.serverError))
    }

    @Test func login_callsGoToMainTabWhenLoginServiceFinishedSuccessfully() async {
        var goToMainTabCalled = false
        let (sut, _) = makeSUT { _ in
            goToMainTabCalled = true
        }
        sut.email = anyEmail()
        sut.password = anyPassword()

        await sut.login()

        #expect(goToMainTabCalled)
    }

    // MARK: - Helpers

    private func makeSUT(goToMainTab: @escaping (User) -> Void = { _ in }) -> (sut: LoginViewModel, loginService: LoginServiceSpy) {
        let loginServiceSpy = LoginServiceSpy()
        let sut = LoginViewModel(loginService: loginServiceSpy, goToMainTab: goToMainTab)
        return (sut, loginServiceSpy)
    }

    private func assertLogin(on sut: LoginViewModel,
                             withExpectedResult expectedResult: LoginViewModel.State,
                             sourceLocation: SourceLocation = #_sourceLocation) async {
        let registerResultSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())

        #expect(registerResultSpy.results == [.idle], sourceLocation: sourceLocation)

        await sut.login()

        #expect(registerResultSpy.results == [.idle, .isLoading, expectedResult], sourceLocation: sourceLocation)
        registerResultSpy.cancel()
    }

    private func anyEmail() -> String {
        "invalid email"
    }

    private func anyPassword() -> String {
        "ABCabc123%"
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }

    private class LoginServiceSpy: LoginService {
        var errorToThrow: Error?
        private(set) var capturedValues = [(email: String, password: String)]()

        func login(email: String, password: String) async throws -> User {
            capturedValues.append((email, password))

            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }

            return anyUser()
        }

        private func anyName() -> String {
            "any name"
        }

        private func anyEmail() -> String {
            "invalid email"
        }

        private func anyUser() -> User {
            User(id: UUID(),
                       name: "any name",
                       email: "any@email.com",
                       profileImage: nil)
        }
    }
}

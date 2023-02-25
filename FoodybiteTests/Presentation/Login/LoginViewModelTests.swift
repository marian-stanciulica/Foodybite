//
//  LoginViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import XCTest
import Foodybite
import Domain

final class LoginViewModelTests: XCTestCase {
    
    func test_loginError_rawValueOfServerError() {
        XCTAssertEqual(LoginViewModel.LoginError.serverError.rawValue, "Invalid Credentials")
    }
    
    func test_state_initiallyIdle() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_isLoading_isTrueOnlyWhenRegisterResultIsLoading() {
        let (sut, _) = makeSUT()

        sut.state = .idle
        XCTAssertFalse(sut.isLoading)
        
        sut.state = .isLoading
        XCTAssertTrue(sut.isLoading)
        
        sut.state = .failure(.serverError)
        XCTAssertFalse(sut.isLoading)
        
        sut.state = .success
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_login_sendsInputsToLoginService() async {
        let (sut, loginServiceSpy) = makeSUT()
        sut.email = anyEmail()
        sut.password = anyPassword()
        
        await sut.login()
        
        XCTAssertEqual(loginServiceSpy.capturedValues.map(\.email), [anyEmail()])
        XCTAssertEqual(loginServiceSpy.capturedValues.map(\.password), [anyPassword()])
        
        await sut.login()
        
        XCTAssertEqual(loginServiceSpy.capturedValues.map(\.email), [anyEmail(), anyEmail()])
        XCTAssertEqual(loginServiceSpy.capturedValues.map(\.password), [anyPassword(), anyPassword()])
    }
    
    func test_login_throwsErrorWhenLoginServiceThrowsError() async {
        let (sut, loginServiceSpy) = makeSUT()
        sut.email = anyEmail()
        sut.password = anyPassword()
        
        let expectedError = anyNSError()
        loginServiceSpy.errorToThrow = expectedError
        
        await sut.login()
        XCTAssertEqual(sut.state, .failure(.serverError))
    }
    
    func test_login_callsGoToMainTabWhenLoginServiceFinishedSuccessfully() async {
        var goToMainTabCalled = false
        let (sut, _) = makeSUT() { _ in
            goToMainTabCalled = true
        }
        sut.email = anyEmail()
        sut.password = anyPassword()
        
        await sut.login()
        
        XCTAssertTrue(goToMainTabCalled)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(goToMainTab: @escaping (User) -> Void = { _ in }) -> (sut: LoginViewModel, loginService: LoginServiceSpy) {
        let loginServiceSpy = LoginServiceSpy()
        let sut = LoginViewModel(loginService: loginServiceSpy, goToMainTab: goToMainTab)
        return (sut, loginServiceSpy)
    }
    
    private func assertLogin(on sut: LoginViewModel,
                             withExpectedResult expectedResult: LoginViewModel.State,
                             file: StaticString = #file,
                             line: UInt = #line) async {
        let registerResultSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())

        XCTAssertEqual(registerResultSpy.results, [.idle], file: file, line: line)
        
        await sut.login()
        
        XCTAssertEqual(registerResultSpy.results, [.idle, .isLoading, expectedResult], file: file, line: line)
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

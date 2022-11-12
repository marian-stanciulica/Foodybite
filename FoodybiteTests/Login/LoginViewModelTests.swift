//
//  LoginViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import XCTest
import FoodybiteNetworking

class LoginViewModel {
    private let loginService: LoginService
    
    var email = ""
    var password = ""
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func login() async {
        _ = try! await loginService.login(email: email, password: password)
    }
}

final class LoginViewModelTests: XCTestCase {
    
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
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LoginViewModel, loginService: LoginServiceSpy) {
        let loginServiceSpy = LoginServiceSpy()
        let sut = LoginViewModel(loginService: loginServiceSpy)
        return (sut, loginServiceSpy)
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

        func login(email: String, password: String) async throws -> LoginResponse {
            capturedValues.append((email, password))

            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
            
            return LoginResponse(name: anyName(), email: anyEmail())
        }
        
        private func anyName() -> String {
            "any name"
        }
        
        private func anyEmail() -> String {
            "invalid email"
        }
    }
}

//
//  AccountEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybiteNetworking

final class AccountEndpointTests: XCTestCase {
    
    // MARK: - Update Account
    
    func test_updateAccount_path() {
        XCTAssertEqual(makeUpdateAccountSUT().path, "/auth/account")
    }
    
    func test_updateAccount_methodIsPost() {
        XCTAssertEqual(makeUpdateAccountSUT().method, .post)
    }
    
    func test_updateAccount_bodyContainsUpdateAccountRequest() throws {
        let body = UpdateAccountRequest(name: anyName(), email: anyEmail(), profileImage: anyData())
        let sut = makeUpdateAccountSUT(body: body)
        
        let receivedBody = try XCTUnwrap(sut.body as? UpdateAccountRequest)
        XCTAssertEqual(receivedBody, body)
    }
    
    // MARK: - Delete Account
    
    func test_deleteAccount_path() {
        XCTAssertEqual(makeDeleteAccountSUT().path, "/auth/account")
    }
    
    func test_deleteAccount_methodIsPost() {
        XCTAssertEqual(makeDeleteAccountSUT().method, .delete)
    }
    
    // MARK: - Helpers
    
    private func makeUpdateAccountSUT(body: UpdateAccountRequest? = nil) -> AccountEndpoint {
        let defaultBody = UpdateAccountRequest(name: "", email: "", profileImage: nil)
        return .updateAccount(body ?? defaultBody)
    }
    
    private func makeDeleteAccountSUT() -> AccountEndpoint {
        return .deleteAccount
    }
    
    private func anyName() -> String {
        "any name"
    }
    
    private func anyEmail() -> String {
        "email@any.com"
    }
}

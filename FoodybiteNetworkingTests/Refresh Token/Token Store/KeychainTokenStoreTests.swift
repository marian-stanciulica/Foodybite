//
//  KeychainTokenStoreTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 16.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

final class KeychainTokenStoreTests: XCTestCase {
   
    override func setUpWithError() throws {
        try? makeSut().delete()
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        try? makeSut().delete()
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_read_shouldThrowWhenNoTokenInStore() {
        XCTAssertThrowsError(try makeSut().read())
    }
    
    func test_write_shouldNotThrowError() {
        XCTAssertNoThrow(try writeDefaultToken(using: makeSut()))
    }
    
    func test_read_shouldDeliverTokenAfterWrite() throws {
        let expectedToken = AuthToken(accessToken: "access token",
                                      refreshToken: "refresh_token")
        try verifyWriteRead(given: makeSut(), for: expectedToken)
    }
    
    func test_write_shouldUpdateValueWhenKeyAlreadyInKeychain() throws {
        let sut = makeSut()
        
        try writeDefaultToken(using: sut)
        
        let expectedToken = AuthToken(accessToken: "expected access token",
                                      refreshToken: "expected refresh_token")
        try verifyWriteRead(given: sut, for: expectedToken)
    }
    
    func test_write_shouldDeliverTokenAfterWriteUsingAnotherInstance() throws {
        try writeDefaultToken(using: makeSut())
        
        let expectedToken = AuthToken(accessToken: "expected access token",
                                      refreshToken: "expected refresh_token")
        try verifyWriteRead(given: makeSut(), for: expectedToken)
    }
    
    // MARK: - Helpers
    
    private func makeSut() -> KeychainTokenStore {
        let service = "test service"
        let account = "test account"
        return KeychainTokenStore(service: service,
                                  account: account)
    }
 
    private func writeDefaultToken(using sut: KeychainTokenStore) throws {
        let firstToken = AuthToken(accessToken: "default access token",
                                   refreshToken: "default refresh_token")
        
        try sut.write(firstToken)
    }
    
    private func verifyWriteRead(given sut: KeychainTokenStore, for expectedToken: AuthToken) throws {
        try sut.write(expectedToken)
        
        let receivedToken = try sut.read()
        
        XCTAssertEqual(expectedToken.accessToken, receivedToken.accessToken)
        XCTAssertEqual(expectedToken.refreshToken, receivedToken.refreshToken)
    }

}

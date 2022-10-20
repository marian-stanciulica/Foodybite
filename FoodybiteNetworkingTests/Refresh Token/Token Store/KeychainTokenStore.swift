//
//  KeychainTokenStore.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 16.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
}

class KeychainTokenStore {
    private let service: String
    private let account: String
    private let codableDataParser = CodableDataParser()
    
    private enum Error: Swift.Error {
        case notFound
        case invalidData
        case writeFailed
    }
    
    init(service: String = "store", account: String = "token") {
        self.service = service
        self.account = account
    }
    
    func read() throws -> AuthToken {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        SecItemCopyMatching(query, &result)

        guard let data = result as? Data else {
            throw Error.notFound
        }
        
        guard let token: AuthToken = try codableDataParser.decode(data: data) else {
            throw Error.invalidData
        }
        
        return token
    }
    
    func write(_ token: AuthToken) throws {
        let data = try codableDataParser.encode(item: token)
        
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        let status = SecItemAdd(query, nil)

        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary

            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            SecItemUpdate(query, attributesToUpdate)
        } else if status != errSecSuccess {
            throw Error.writeFailed
        }
    }
    
}

final class KeychainTokenStoreTests: XCTestCase {
    private static let service = "test service"
    private static let account = "test account"
    
    override func setUp() {
        deleteKey()
        super.setUp()
    }
    
    override func tearDown() {
        deleteKey()
        super.tearDown()
    }
    
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
    
    func test_read_throwsInvalidDataErrorAfterRandomWrite() throws {
        write(data: anyData())
        
        XCTAssertThrowsError(try makeSut().read())
    }
    
    // MARK: - Helpers
    
    private func makeSut() -> KeychainTokenStore {
        return KeychainTokenStore(service: KeychainTokenStoreTests.service,
                                  account: KeychainTokenStoreTests.account)
    }
    
    private func anyData() -> Data {
        "any data".data(using: .utf8)!
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
    
    private func write(data: Data) {
        let query = [
            kSecValueData: data,
            kSecAttrService: KeychainTokenStoreTests.service,
            kSecAttrAccount: KeychainTokenStoreTests.account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        SecItemAdd(query, nil)
    }
    
    private func deleteKey() {
        let query = [
            kSecAttrService: KeychainTokenStoreTests.service,
            kSecAttrAccount: KeychainTokenStoreTests.account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        SecItemDelete(query)
    }

}

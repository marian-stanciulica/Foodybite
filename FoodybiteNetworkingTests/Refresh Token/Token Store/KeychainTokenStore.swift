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
        let expectedToken = AuthToken(accessToken: "access token",
                                      refreshToken: "refresh_token")
        
        XCTAssertNoThrow(try makeSut().write(expectedToken))
    }
    
    func test_read_shouldDeliverTokenAfterWrite() throws {
        let sut = makeSut()
        let expectedToken = AuthToken(accessToken: "access token",
                                      refreshToken: "refresh_token")
        
        try sut.write(expectedToken)
        let receivedToken = try sut.read()
        
        XCTAssertEqual(expectedToken.accessToken, receivedToken.accessToken)
        XCTAssertEqual(expectedToken.refreshToken, receivedToken.refreshToken)
    }
    
    func test_write_shouldUpdateValueWhenKeyAlreadyInKeychain() throws {
        let sut = makeSut()
        let firstToken = AuthToken(accessToken: "first access token",
                                   refreshToken: "first refresh_token")
        
        try sut.write(firstToken)
        
        let expectedToken = AuthToken(accessToken: "expected access token",
                                      refreshToken: "expected refresh_token")
        
        try sut.write(expectedToken)
        
        let receivedToken = try sut.read()
        
        XCTAssertEqual(expectedToken.accessToken, receivedToken.accessToken)
        XCTAssertEqual(expectedToken.refreshToken, receivedToken.refreshToken)
    }
    
    // MARK: - Helpers
    
    private func makeSut() -> KeychainTokenStore {
        return KeychainTokenStore(service: KeychainTokenStoreTests.service,
                                  account: KeychainTokenStoreTests.account)
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

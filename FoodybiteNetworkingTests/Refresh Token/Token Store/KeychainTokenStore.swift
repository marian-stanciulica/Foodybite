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
    private let service = "store"
    private let account = "token"
    private let codableDataParser = CodableDataParser()
    
    private enum Error: Swift.Error {
        case notFound
    }
    
    func read() throws -> AuthToken {
        throw Error.notFound
    }
    
    func write(_ token: AuthToken) throws {
        let data = try codableDataParser.encode(item: token)
        
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        SecItemAdd(query, nil)
    }
    
}

final class KeychainTokenStoreTests: XCTestCase {
    private var sut: KeychainTokenStore!
    
    override func setUp() {
        super.setUp()
        
        sut = KeychainTokenStore()
    }
    
    func test_read_shouldThrowWhenNoTokenInStore() {
        XCTAssertThrowsError(try sut.read())
    }
    
    func test_write_shouldNotThrowError() {
        let expectedToken = AuthToken(accessToken: "access token",
                                      refreshToken: "refresh_token")
        
        XCTAssertNoThrow(try sut.write(expectedToken))
    }

}

//
//  KeychainTokenStore.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 16.10.2022.
//

import XCTest

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
}

class KeychainTokenStore {
    
    private enum Error: Swift.Error {
        case notFound
    }
    
    func read() throws {
        throw Error.notFound
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
    

}

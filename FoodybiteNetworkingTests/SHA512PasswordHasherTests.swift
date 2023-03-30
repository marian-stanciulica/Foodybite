//
//  SHA512PasswordHasherTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 30.03.2023.
//

import XCTest
import CryptoKit

final class SHA512PasswordHasher {
    
    static func hash(password: String) -> String {
        let hashed = SHA512.hash(data: password.data(using: .utf8)!)
        return hashed.compactMap { String(format: "%02x", $0) } .joined()
    }
    
}

final class SHA512PasswordHasherTests: XCTestCase {
    
    func test_hash_returnsHashWhenPasswordIsEmpty() {
        let password = ""
        let hashed = SHA512PasswordHasher.hash(password: password)
        
        XCTAssertEqual(hashed.count, 128)
    }
    
}

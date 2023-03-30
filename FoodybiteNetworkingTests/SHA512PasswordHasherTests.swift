//
//  SHA512PasswordHasherTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 30.03.2023.
//

import XCTest
@testable import FoodybiteNetworking

final class SHA512PasswordHasherTests: XCTestCase {
    
    func test_hash_hasCorrectHashSizeWhenPasswordIsEmpty() {
        let password = ""
        let hash = SHA512PasswordHasher.hash(password: password)
        
        XCTAssertEqual(hash.count, 128)
    }
    
    func test_hash_hasCorrectHashSizeWhenPasswordIsReallyLong() {
        let password = "qPz5GBjUyxTVUZ6k4Cr5V7RSNTWpGfcUB5jwsfq22WXhpbezH3vNwLyMRQPaxYVJVzhgJ7JpduQSvRmpYvxvWa2qn4WLkxGvaDG3fq9mgB6SThtXutJHDw4q"
        let hash = SHA512PasswordHasher.hash(password: password)
        
        XCTAssertEqual(hash.count, 128)
    }
    
    func test_hash_outputsSameHashWhenHashingTwiceSamePassword() {
        let password = "qPz5GBjUyxTVUZ6k4Cr5V7RSNTWpGfcUB5"
        let firstHash = SHA512PasswordHasher.hash(password: password)
        let secondHash = SHA512PasswordHasher.hash(password: password)
        
        XCTAssertEqual(firstHash, secondHash)
    }
    
}

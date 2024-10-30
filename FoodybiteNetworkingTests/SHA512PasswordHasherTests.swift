//
//  SHA512PasswordHasherTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 30.03.2023.
//

import Testing
@testable import FoodybiteNetworking

struct SHA512PasswordHasherTests {

    @Test func hash_hasCorrectHashSizeWhenPasswordIsEmpty() {
        let password = ""
        let hash = SHA512PasswordHasher.hash(password: password)

        #expect(hash.count == 128)
    }

    @Test func hash_hasCorrectHashSizeWhenPasswordIsReallyLong() {
        let password = "qPz5GBjUyxTVUZ6k4Cr5V7RSNTWpGfcUB5jwsfq22WXhpbezH3vNwLyMRQPaxYVJVzhgJ7JpduQSvRmpYvxvWa2qn4WLkxGvaDG3fq9mgB6SThtXutJHDw4q"
        let hash = SHA512PasswordHasher.hash(password: password)

        #expect(hash.count == 128)
    }

    @Test func hash_outputsSameHashWhenHashingTwiceSamePassword() {
        let password = "qPz5GBjUyxTVUZ6k4Cr5V7RSNTWpGfcUB5"
        let firstHash = SHA512PasswordHasher.hash(password: password)
        let secondHash = SHA512PasswordHasher.hash(password: password)

        #expect(firstHash == secondHash)
    }

}

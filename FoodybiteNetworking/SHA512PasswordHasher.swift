//
//  SHA512PasswordHasher.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 30.03.2023.
//

import CryptoKit

final class SHA512PasswordHasher {

    static func hash(password: String) -> String {
        let hashed = SHA512.hash(data: password.data(using: .utf8)!)
        return hashed.compactMap { String(format: "%02x", $0) } .joined()
    }

}

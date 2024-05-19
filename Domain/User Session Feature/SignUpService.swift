//
//  SignUpService.swift
//  Domain
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation

public protocol SignUpService: Sendable {
    func signUp(name: String, email: String, password: String, profileImage: Data?) async throws
}

//
//  LoginService.swift
//  Domain
//
//  Created by Marian Stanciulica on 15.10.2022.
//

public protocol LoginService: Sendable {
    func login(email: String, password: String) async throws -> User
}

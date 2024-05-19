//
//  LogoutService.swift
//  Domain
//
//  Created by Marian Stanciulica on 24.11.2022.
//

public protocol LogoutService: Sendable {
    func logout() async throws
}

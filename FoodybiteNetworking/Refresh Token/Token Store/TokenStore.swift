//
//  TokenStore.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 16.10.2022.
//

public protocol TokenStore: Sendable {
    func read() throws -> AuthToken
    func write(_ token: AuthToken) throws
    func delete() throws
}

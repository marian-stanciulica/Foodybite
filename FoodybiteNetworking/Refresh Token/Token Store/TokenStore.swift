//
//  TokenStore.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 16.10.2022.
//

import Foundation

public protocol TokenStore {
    func read() throws -> AuthToken
    func write(_ token: AuthToken) throws
    func delete() throws
}

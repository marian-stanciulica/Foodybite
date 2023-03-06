//
//  NullUserStore.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 06.03.2023.
//

import FoodybitePersistence

final class NullUserStore: UserStore {
    private struct CacheMissError: Error {}

    func read() async throws -> LocalUser {
        throw CacheMissError()
    }
    
    func write(_ user: LocalUser) async throws {}
    func delete() async throws {}
}

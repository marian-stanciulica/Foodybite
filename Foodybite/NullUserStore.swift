//
//  NullUserStore.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 06.03.2023.
//

import Domain
import FoodybitePersistence

final class NullUserStore: UserStore {
    private struct CacheMissError: Error {}

    func read() async throws -> User {
        throw CacheMissError()
    }
    
    func write(_ user: User) async throws {}
    func delete() async throws {}
}

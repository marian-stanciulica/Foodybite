//
//  NullUserStore.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 06.03.2023.
//

import Domain
import FoodybitePersistence

final class NullUserStore: LocalStore {
    private struct CacheMissError: Error {}

    func read<T: LocalModelConvertable>() async throws -> T {
        throw CacheMissError()
    }
    
    func readAll<T: LocalModelConvertable>() async throws -> [T] {
        throw CacheMissError()
    }
    
    func write<T: LocalModelConvertable>(_ user: T) async throws {}
}

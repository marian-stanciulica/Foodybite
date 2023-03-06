//
//  LocalUserLoader.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import Domain

public class LocalUserLoader<T: LocalModelConvertable, Store: UserStore> where Store.LocalModel == T.LocalModel {
    private let store: Store
    
    public init(store: Store) {
        self.store = store
    }
    
    public func load() async throws -> T {
        let local = try await store.read()
        return T(from: local)
    }
    
    public func save(user: T) async throws {
        try await store.delete()
        try await store.write(user.toLocalModel())
    }
}

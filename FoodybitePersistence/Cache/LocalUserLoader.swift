//
//  LocalUserLoader.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import Domain

public class LocalUserLoader<T: LocalModelConvertable, Store: UserStore> where Store.LocalModel == T {
    private let store: Store
    
    public init(store: Store) {
        self.store = store
    }
    
    public func load() async throws -> T {
        try await store.read()
    }
    
    public func save(user: T) async throws {
        try await store.delete()
        try await store.write(user)
    }
}

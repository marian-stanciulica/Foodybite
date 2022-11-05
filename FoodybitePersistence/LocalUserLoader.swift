//
//  LocalResourceLoader.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

#warning("Create a local User model and delete the import")
import DomainModels

public class LocalUserLoader {
    private let store: UserStore
    
    public init(store: UserStore) {
        self.store = store
    }
    
    public func load() async throws -> User {
        return try await store.read()
    }
    
    public func save(user: User) async throws {
        try await store.delete()
        try await store.write(user)
    }
}

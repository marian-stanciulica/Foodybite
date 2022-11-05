//
//  RealmUserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import RealmSwift

final public class RealmUserStore: UserStore {
    private let realm: Realm
    
    public init(inMemoryIdentifier: String? = nil) throws {
        let configuration = Realm.Configuration(inMemoryIdentifier: inMemoryIdentifier)
        realm = try Realm(configuration: configuration)
    }
    
    public func read() async throws -> LocalUser {
        let results = realm.objects(RealmUser.self)
        
        if let first = results.first {
            return first.local
        } else {
            throw NSError(domain: "any error", code: 0)
        }
    }
    
    public func write(_ user: LocalUser) async throws {
        try realm.write {
            deleteAll()
            
            realm.add(RealmUser(user: user))
        }
    }
    
    public func delete() async throws {
        try realm.write {
            deleteAll()
        }
    }
    
    private func deleteAll() {
        let results = realm.objects(RealmUser.self)
        results.forEach(realm.delete)
    }
    
}

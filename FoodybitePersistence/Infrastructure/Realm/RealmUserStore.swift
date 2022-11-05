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
        LocalUser(id: UUID(), name: "", email: "", profileImage: URL(string: "http://any.com")!)
    }
    
    public func write(_ user: LocalUser) async throws {
        
    }
    
    public func delete() async throws {
        
    }
    
}

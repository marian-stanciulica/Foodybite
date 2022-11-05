//
//  CoreDataUserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import CoreData

public class CoreDataUserStore: UserStore {
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func read() async throws -> LocalUser {
        LocalUser(id: UUID(), name: "", email: "", profileImage: URL(string: "http://any.com")!)
    }
    
    public func write(_ user: LocalUser) async throws {
    
    }
    
    public func delete() async throws {
        
    }
}

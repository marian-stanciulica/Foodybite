//
//  CoreDataUserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import CoreData

public class CoreDataUserStore: UserStore {
    private let context: NSManagedObjectContext
    
    private struct CacheMissError: Error {}
    
    public init(storeURL: URL, bundle: Bundle = .init(for: CoreDataUserStore.self)) throws {
        let container = try NSPersistentContainer.load(modelName: "Store", bundle: bundle, storeURL: storeURL)
        context = container.newBackgroundContext()
    }
    
    public func read() async throws -> LocalUser {
        try await context.perform {
            let results = try self.context.fetch(ManagedUser.fetchRequest())
            
            if let firstResult = results.first {
                return firstResult.local
            } else {
                throw CacheMissError()
            }
        }
    }
    
    public func write(_ user: LocalUser) async throws {
        try await context.perform {
            try self.deleteAll(context: self.context)
            
            self.context.insert(ManagedUser(user, for: self.context))
            try self.context.save()
        }
    }
    
    public func delete() async throws {
        try await context.perform {
            try self.deleteAll(context: self.context)
        }
    }
    
    private func deleteAll(context: NSManagedObjectContext) throws {
        let results = try self.context.fetch(ManagedUser.fetchRequest())
        results.forEach(self.context.delete)
    }
    
}

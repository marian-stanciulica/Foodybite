//
//  CoreDataUserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import CoreData

public class CoreDataUserStore<T: LocalModelConvertable>: UserStore {
    private let context: NSManagedObjectContext
    
    private struct CacheMissError: Error {}
    
    public init(storeURL: URL, bundle: Bundle = .init(for: CoreDataUserStore.self)) throws {
        let container = try NSPersistentContainer.load(modelName: "Store", bundle: bundle, storeURL: storeURL)
        context = container.newBackgroundContext()
    }
    
    public func read() async throws -> T {
        try await context.perform {
            let results = try self.context.fetch(ManagedUser.fetchRequest())
            
            if let firstResult = results.first as? T.LocalModel {
                return T(from: firstResult)
            } else {
                throw CacheMissError()
            }
        }
    }
    
    public func write(_ user: T) async throws {
        try await context.perform {
            try self.deleteAll(context: self.context)
            
            self.context.insert(user.toLocalModel(context: self.context))
            try self.context.save()
        }
    }
    
    private func deleteAll(context: NSManagedObjectContext) throws {
        let results = try self.context.fetch(ManagedUser.fetchRequest())
        results.forEach(self.context.delete)
    }
    
}

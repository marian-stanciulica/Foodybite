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
    
    public func read<T: LocalModelConvertable>() async throws -> T {
        try await context.perform {
            let results = try self.context.fetch(T.LocalModel.fetchRequest())
            
            if let firstResult = results.first as? T.LocalModel {
                return T(from: firstResult)
            } else {
                throw CacheMissError()
            }
        }
    }
    
    public func write<T: LocalModelConvertable>(_ object: T) async throws {
        try await context.perform {
            let request = T.LocalModel.fetchRequest()
            
            if let results = try self.context.fetch(request) as? [T.LocalModel] {
                for object in results {
                    self.context.delete(object)
                }
            }
            
            self.context.insert(object.toLocalModel(context: self.context))
            try self.context.save()
        }
    }
}

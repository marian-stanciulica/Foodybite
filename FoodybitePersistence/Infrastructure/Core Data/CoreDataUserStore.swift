//
//  CoreDataUserStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import CoreData

public class CoreDataUserStore: UserStore {
    private let context: NSManagedObjectContext
    
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    private struct CacheMissError: Error {}
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        guard let model = NSManagedObjectModel.with(name: "Store", in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let container = NSPersistentContainer(name: "Store", managedObjectModel: model)
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }
        
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
            self.context.insert(ManagedUser(user, for: self.context))
            try self.context.save()
        }
    }
    
    public func delete() async throws {
        
    }
    
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

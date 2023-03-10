//
//  CoreDataLocalStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Domain
import CoreData

public class CoreDataLocalStore: LocalStore {
    private let context: NSManagedObjectContext
    
    private struct CacheMissError: Error {}
    
    public init(storeURL: URL, bundle: Bundle = .init(for: CoreDataLocalStore.self)) throws {
        let container = try NSPersistentContainer.load(modelName: "Store", bundle: bundle, storeURL: storeURL)
        context = container.newBackgroundContext()
    }
    
    public func read<T: LocalModelConvertable>() async throws -> T {
        if let firstObject: T = try await readAll().first {
            return firstObject
        }
        
        throw CacheMissError()
    }
    
    public func readAll<T: LocalModelConvertable>() async throws -> [T] {
        try await context.perform {
            let request = T.LocalModel.fetchRequest()
            
            if let results = try self.context.fetch(request) as? [T.LocalModel] {
                return results.map { T(from: $0) }
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
    
    public func writeAll<T>(_ objects: [T]) async throws where T : LocalModelConvertable {
        for object in objects {
            try await write(object)
        }
    }
}

extension CoreDataLocalStore: FetchPlacePhotoService {
    public func fetchPlacePhoto(photoReference: String) async throws -> Data {
        guard let foundPhoto = try ManagedPhoto.first(with: photoReference, in: context),
              let photoData = foundPhoto.photoData else {
            throw CacheMissError()
        }
        
        return photoData
    }
}

extension CoreDataLocalStore: PlacePhotoCache {
    public func save(photoData: Data, for photoReference: String) async throws {
        guard let photo = try ManagedPhoto.first(with: photoReference, in: context) else {
            throw CacheMissError()
        }
        
        photo.photoData = photoData
        try context.save()
    }
    
}

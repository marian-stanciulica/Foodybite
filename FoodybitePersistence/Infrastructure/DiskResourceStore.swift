//
//  DiskResourceStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Foundation

public class DiskResourceStore<T: Codable>: ResourceStore {
    private let storeURL: URL
    
    private struct CacheMissError: Error {}
    
    public init(storeURL: URL) {
        self.storeURL = storeURL.appending(path: "\(T.self).resource")
    }
    
    public func read() async throws -> T {
        guard let data = try? Data(contentsOf: storeURL) else {
            throw CacheMissError()
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    public func write(_ object: T) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        try data.write(to: storeURL)
    }
    
    public func delete(_ type: T.Type) async throws {
        if FileManager.default.fileExists(atPath: storeURL.path()) {
            try FileManager.default.removeItem(at: storeURL)
        }
    }
}

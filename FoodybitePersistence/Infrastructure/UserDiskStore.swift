//
//  DiskResourceStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

#warning("Create a local User model and delete the import")
import DomainModels

public class UserDiskStore: UserStore {
    private let storeURL: URL
    
    private struct CacheMissError: Error {}
    
    public init(storeURL: URL) {
        self.storeURL = storeURL.appending(path: "User.resource")
    }
    
    public func read() async throws -> User {
        guard let data = try? Data(contentsOf: storeURL) else {
            throw CacheMissError()
        }
        
        let decoder = JSONDecoder()
        let decodableUser = try decoder.decode(CodableUser.self, from: data)
        return decodableUser.original
    }
    
    public func write(_ user: User) async throws {
        let encoder = JSONEncoder()
        let encodableUser = CodableUser(user: user)
        let data = try encoder.encode(encodableUser)
        try data.write(to: storeURL)
    }
    
    public func delete() async throws {
        if FileManager.default.fileExists(atPath: storeURL.path()) {
            try FileManager.default.removeItem(at: storeURL)
        }
    }
}

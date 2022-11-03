//
//  LocalResourceLoader.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 03.11.2022.
//

public class LocalResourceLoader<Client: ResourceStore> {
    private let client: Client
    
    public init(client: Client) {
        self.client = client
    }
    
    public func load() async throws -> Client.T {
        return try await client.read()
    }
    
    public func save(object: Client.T) async throws {
        try await client.delete(Client.T.self)
        try await client.write(object)
    }
}

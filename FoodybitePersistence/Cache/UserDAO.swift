//
//  UserDAO.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Foundation
import Domain

public final class UserDAO {
    private let store: LocalStore
    
    private struct UserNotFound: Error {}
    
    public init(store: LocalStore) {
        self.store = store
    }
    
    public func getUser(id: UUID) async throws -> User {
        let users: [User] = try await store.readAll()
        
        guard let foundUser = users.first(where: { $0.id == id }) else {
            throw UserNotFound()
        }
        
        return foundUser
    }
}

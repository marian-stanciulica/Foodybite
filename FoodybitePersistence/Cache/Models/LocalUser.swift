//
//  LocalUser.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Foundation
import Domain

public struct LocalUser: Equatable {
    public let id: UUID
    public let name: String
    public let email: String
    public let profileImage: Data?
    
    public init(id: UUID, name: String, email: String, profileImage: Data?) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImage = profileImage
    }
}

extension User: LocalModelConvertable {
    public init(from localUser: LocalUser) {
        self.init(id: localUser.id, name: localUser.name, email: localUser.email, profileImage: localUser.profileImage)
    }
    
    public func toLocalModel() -> LocalUser {
        LocalUser(id: id, name: name, email: email, profileImage: profileImage)
    }
}

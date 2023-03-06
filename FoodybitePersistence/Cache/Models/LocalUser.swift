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
    
    public init(user: User) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.profileImage = user.profileImage
    }
    
    public var model: User {
        User(id: id, name: name, email: email, profileImage: profileImage)
    }
}
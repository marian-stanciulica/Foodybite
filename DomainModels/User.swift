//
//  User.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Foundation

public struct User: Equatable {
    public let id: UUID
    public let name: String
    public let email: String
    public let profileImage: URL
    
    public init(id: UUID, name: String, email: String, profileImage: URL) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImage = profileImage
    }
}
//
//  CodableUser.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import DomainModels

struct CodableUser: Codable {
    let id: UUID
    let name: String
    let email: String
    let profileImage: URL
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.profileImage = user.profileImage
    }
    
    var original: User {
        User(id: id, name: name, email: email, profileImage: profileImage)
    }
}

//
//  CodableUser.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Foundation

struct CodableUser: Codable {
    let id: UUID
    let name: String
    let email: String
    let profileImage: Data?
    
    init(_ user: LocalUser) {
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.profileImage = user.profileImage
    }
    
    var local: LocalUser {
        LocalUser(id: id, name: name, email: email, profileImage: profileImage)
    }
}

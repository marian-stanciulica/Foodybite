//
//  RemoteUser.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 19.11.2022.
//

import Foundation
import Domain

struct RemoteUser: Decodable, Equatable {
    let id: UUID
    let name: String
    let email: String
    let profileImage: Data?
    
    var model: User {
        User(id: id, name: name, email: email, profileImage: profileImage)
    }
}

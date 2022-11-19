//
//  RemoteUser.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 19.11.2022.
//

import Foundation

public struct RemoteUser: Decodable, Equatable {
    let id: UUID
    let name: String
    let email: String
    let profileImage: Data?
    let followingCount: Int
    let followersCount: Int
    
    public init(id: UUID, name: String, email: String, profileImage: Data?, followingCount: Int, followersCount: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImage = profileImage
        self.followingCount = followingCount
        self.followersCount = followersCount
    }
}

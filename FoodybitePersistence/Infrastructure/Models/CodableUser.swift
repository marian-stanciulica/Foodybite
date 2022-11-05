//
//  CodableUser.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Foundation

struct User: Codable {
    let id: UUID
    let name: String
    let email: String
    let profileImage: URL
}

//
//  RealmUser.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import RealmSwift

public class RealmUser: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var profileImage: String

    convenience init(user: LocalUser) {
        self.init()
        
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.profileImage = user.profileImage.absoluteString
    }
    
    public var local: LocalUser {
        LocalUser(id: id, name: name, email: email, profileImage: URL(string: profileImage)!)
    }
}

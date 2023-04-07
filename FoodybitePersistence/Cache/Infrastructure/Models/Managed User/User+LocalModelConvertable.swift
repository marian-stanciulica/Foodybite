//
//  User+LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Domain
import CoreData

extension User: LocalModelConvertable {
    public init(from managedUser: ManagedUser) {
        self.init(id: managedUser.id,
                  name: managedUser.name,
                  email: managedUser.email,
                  profileImage: managedUser.profileImage)
    }

    public func toLocalModel(context: NSManagedObjectContext) -> ManagedUser {
        ManagedUser(self, for: context)
    }
}

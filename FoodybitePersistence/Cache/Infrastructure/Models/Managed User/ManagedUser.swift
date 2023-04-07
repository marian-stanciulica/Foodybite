//
//  ManagedUser.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Foundation
import CoreData
import Domain

@objc(ManagedUser)
public class ManagedUser: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var profileImage: Data?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedUser> {
        return NSFetchRequest<ManagedUser>(entityName: "ManagedUser")
    }

    public convenience init(_ model: User, for context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = model.id
        self.name = model.name
        self.email = model.email
        self.profileImage = model.profileImage
    }
}

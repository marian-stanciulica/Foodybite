//
//  ManagedUser.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Foundation
import CoreData

@objc(ManagedUser)
public class ManagedUser: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var profileImage: Data?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedUser> {
        return NSFetchRequest<ManagedUser>(entityName: "ManagedUser")
    }
    
    convenience init(_ user: LocalUser, for context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = user.id
        self.name = user.name
        self.email = user.email
        self.profileImage = user.profileImage
    }
    
    var local: LocalUser {
        LocalUser(id: id, name: name, email: email, profileImage: profileImage)
    }
}

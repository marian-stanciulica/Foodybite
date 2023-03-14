//
//  ManagedReview+CoreDataClass.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 14.03.2023.
//
//

import Foundation
import CoreData

@objc(ManagedReview)
public class ManagedReview: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var placeID: String
    @NSManaged public var profileImageURL: URL?
    @NSManaged public var profileImageData: Data?
    @NSManaged public var authorName: String
    @NSManaged public var reviewText: String
    @NSManaged public var rating: Int16
    @NSManaged public var relativeTime: String
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedReview> {
        return NSFetchRequest<ManagedReview>(entityName: "ManagedReview")
    }
}

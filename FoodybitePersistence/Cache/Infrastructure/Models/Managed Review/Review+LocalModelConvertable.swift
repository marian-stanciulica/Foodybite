//
//  Review+LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Domain
import CoreData

extension Review: LocalModelConvertable {
    public init(from managedReview: ManagedReview) {
        self.init(
            id: managedReview.id,
            restaurantID: managedReview.restaurantID,
            profileImageURL: managedReview.profileImageURL,
            profileImageData: managedReview.profileImageData,
            authorName: managedReview.authorName,
            reviewText: managedReview.reviewText,
            rating: Int(managedReview.rating),
            relativeTime: managedReview.relativeTime
        )
    }

    public func toLocalModel(context: NSManagedObjectContext) -> ManagedReview {
        ManagedReview(self, for: context)
    }
}

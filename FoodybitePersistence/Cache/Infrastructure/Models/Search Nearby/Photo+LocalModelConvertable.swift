//
//  Photo+LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 09.03.2023.
//

import Domain
import CoreData

extension Photo: LocalModelConvertable {
    public init(from managedPhoto: ManagedPhoto) {
        self.init(width: Int(managedPhoto.width),
                  height: Int(managedPhoto.height),
                  photoReference: managedPhoto.reference)
    }
    
    public func toLocalModel(context: NSManagedObjectContext) -> ManagedPhoto {
        ManagedPhoto(self, for: context)
    }
}

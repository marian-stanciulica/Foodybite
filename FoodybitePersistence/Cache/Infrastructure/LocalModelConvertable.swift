//
//  LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 06.03.2023.
//

import Domain
import CoreData

public protocol LocalModelConvertable {
    associatedtype LocalModel: NSManagedObject
    
    init(from: LocalModel)
    func toLocalModel(context: NSManagedObjectContext) -> LocalModel
}

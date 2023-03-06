//
//  LocalModelConvertable.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 06.03.2023.
//

public protocol LocalModelConvertable {
    associatedtype LocalModel
    
    init(from: LocalModel)
    func toLocalModel() -> LocalModel
}

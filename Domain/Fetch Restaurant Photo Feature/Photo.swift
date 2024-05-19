//
//  Photo.swift
//  Domain
//
//  Created by Marian Stanciulica on 29.01.2023.
//

public struct Photo: Hashable, Sendable {
    public let width: Int
    public let height: Int
    public let photoReference: String

    public init(width: Int, height: Int, photoReference: String) {
        self.width = width
        self.height = height
        self.photoReference = photoReference
    }
}

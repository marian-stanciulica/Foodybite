//
//  Photo.swift
//  Domain
//
//  Created by Marian Stanciulica on 29.01.2023.
//

public struct Photo: Equatable, Hashable {
    public let width: Int
    public let height: Int
    public let photoReference: String
    
    public init(width: Int, height: Int, photoReference: String) {
        self.width = width
        self.height = height
        self.photoReference = photoReference
    }
    
    public static func ==(lhs: Photo, rhs: Photo) -> Bool {
        lhs.width == rhs.width && lhs.height == rhs.height
    }
}


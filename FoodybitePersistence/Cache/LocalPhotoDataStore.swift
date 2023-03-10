//
//  LocalPhotoDataStore.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 10.03.2023.
//

import Foundation

protocol LocalPhotoDataStore {
    func read(photoReference: String) async throws -> Data
    func write(photoData: Data, for photoReference: String) async throws
}

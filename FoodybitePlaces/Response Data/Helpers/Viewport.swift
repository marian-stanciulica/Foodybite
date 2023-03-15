//
//  Viewport.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import Foundation

struct Viewport: Decodable {
    let northeast: RemoteLocation
    let southwest: RemoteLocation
}

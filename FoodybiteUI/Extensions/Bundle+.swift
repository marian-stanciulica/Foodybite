//
//  Bundle+.swift
//  FoodybiteUI
//
//  Created by Marian Stanciulica on 30.03.2023.
//

import Foundation

public extension Bundle {
    static var current: Bundle {
        class BundleIdentifier { }
        return Bundle(for: BundleIdentifier.self)
    }
}

//
//  SharedTestHelpers.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Foundation.NSError

func anyError() -> NSError {
    NSError(domain: "any error", code: 1)
}

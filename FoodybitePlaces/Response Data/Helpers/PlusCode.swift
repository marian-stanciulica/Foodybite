//
//  PlusCode.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import Foundation

struct PlusCode: Decodable {
    let compoundCode: String
    let globalCode: String

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

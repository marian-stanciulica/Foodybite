//
//  AutocompletePlacesService.swift
//  Domain
//
//  Created by Marian Stanciulica on 09.02.2023.
//

protocol AutocompletePlacesService {
    func autocomplete(input: String, location: Location, radius: Int) async throws -> [String]
}

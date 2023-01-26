//
//  SearchViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import DomainModels
import FoodybitePlaces

public class SearchViewModel: ObservableObject {
    private let service: SearchNearbyService
    
    @Published public var searchResults = [NearbyPlace]()
    
    public init(service: SearchNearbyService) {
        self.service = service
    }
    
    public func autocomplete(input: String) async {
        do {
            searchResults = try await service.autocomplete(input: input)
        } catch {
            searchResults = []
        }
    }
}

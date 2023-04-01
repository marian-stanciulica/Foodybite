//
//  Flow.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation

final class Flow<Route: Hashable>: ObservableObject {
    @Published var path = [Route]()
    
    func append(_ value: Route) {
        path.append(value)
    }
    
    func navigateBack() {
        path.removeLast()
    }
}

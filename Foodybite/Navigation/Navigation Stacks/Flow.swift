//
//  Flow.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation

final public class Flow<Route>: ObservableObject {
    @Published public var path = [Route]()
    
    public init() { }
    
    public func append(_ value: Route) {
        path.append(value)
    }
    
    public func navigateBack() {
        path.removeLast()
    }
}

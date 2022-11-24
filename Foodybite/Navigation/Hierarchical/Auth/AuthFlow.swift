//
//  AuthFlow.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import Foundation

final public class AuthFlow: ObservableObject {
    public enum Route: Hashable, CaseIterable {
        case signUp
    }
    
    @Published public var path = [Route]()
    
    public init() { }
    
    public func append(_ value: Route) {
        path.append(value)
    }
    
    public func navigateBack() {
        path.removeLast()
    }
}
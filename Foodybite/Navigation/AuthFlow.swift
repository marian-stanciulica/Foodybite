//
//  AuthFlow.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import SwiftUI

final public class AuthFlow {
    public enum Route: Hashable, CaseIterable {
        case signUp
        case turnOnLocation
    }
    
    public var path = NavigationPath()
    
    public init() { }
    
    public func append(_ value: Route) {
        path.append(value)
    }
    
    public func navigateBack() {
        path.removeLast()
    }
}

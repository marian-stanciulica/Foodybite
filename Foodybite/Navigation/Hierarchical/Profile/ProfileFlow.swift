//
//  ProfileFlow.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Foundation

final public class ProfileFlow: ObservableObject {
    public enum Route: Hashable, CaseIterable {
        case settings
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

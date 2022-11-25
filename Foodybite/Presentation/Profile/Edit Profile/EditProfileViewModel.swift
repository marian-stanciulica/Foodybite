//
//  EditProfileViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation

public final class EditProfileViewModel {
    public enum Error: String, Swift.Error {
        case emptyName = "Empty name"
        case emptyEmail = "Empty email"
        case invalidEmail = "Invalid email"
    }
    
    public enum Result: Equatable {
        case notTriggered
        case success
        case failure(RegisterValidator.Error)
    }
    
    public var name = ""
    @Published public var result: Result = .notTriggered

    public init() {}
    
    public func updateAccount() async {
        if name.isEmpty {
            result = .failure(.emptyName)
        } else {
            result = .failure(.emptyEmail)
        }
    }
    
}

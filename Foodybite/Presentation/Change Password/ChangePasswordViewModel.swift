//
//  ChangePasswordViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Foundation

public final class ChangePasswordViewModel {
    public enum Result: Equatable {
        case notTriggered
        case success
        case failure(PasswordValidator.Error)
    }
    
    public var currentPassword = ""
    @Published public var result: Result = .notTriggered
    
    public init() {
        
    }

    public func changePassword() async {
        do {
            throw PasswordValidator.Error.empty
        } catch {
            if let error = error as? PasswordValidator.Error {
                await updateResult(.failure(error))
            }
        }
    }
    
    @MainActor private func updateResult(_ newValue: Result) {
        result = newValue
    }
}

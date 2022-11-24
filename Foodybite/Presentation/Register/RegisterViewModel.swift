//
//  RegisterViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation
import FoodybiteNetworking

public class RegisterViewModel: ObservableObject {
    private let signUpService: SignUpService
    
    public enum RegisterResult: Equatable {
        case notTriggered
        case success
        case failure(RegisterValidator.Error)
    }
    
    @Published public var name = ""
    @Published public var email = ""
    @Published public var password = ""
    @Published public var confirmPassword = ""
    @Published public var profileImage: Data?
    @Published public var registerResult: RegisterResult = .notTriggered
    
    public init(signUpService: SignUpService) {
        self.signUpService = signUpService
    }
    
    public func register() async {
        do {
            try RegisterValidator.validate(name: name,
                                           email: email,
                                           password: password,
                                           confirmPassword: confirmPassword)
            
            try await signUp()
        } catch {
            if let error = error as? RegisterValidator.Error {
                await updateRegisterResult(.failure(error))
            } else if let error = error as? PasswordValidator.Error {
                await updateRegisterResult(.failure(.passwordError(error)))
            }
        }
    }
    
    private func signUp() async throws {
        do {
            try await signUpService.signUp(name: name,
                                           email: email,
                                           password: password,
                                           confirmPassword: confirmPassword,
                                           profileImage: profileImage)
            await updateRegisterResult(.success)
        } catch {
            throw RegisterValidator.Error.serverError
        }
    }
    
    @MainActor private func updateRegisterResult(_ newValue: RegisterResult) {
        registerResult = newValue
    }
}

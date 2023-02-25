//
//  RegisterViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation
import Domain

public class RegisterViewModel: ObservableObject {
    private let signUpService: SignUpService
    
    public enum State: Equatable {
        case idle
        case isLoading
        case success
        case failure(RegisterValidator.Error)
    }
    
    @Published public var name = ""
    @Published public var email = ""
    @Published public var password = ""
    @Published public var confirmPassword = ""
    @Published public var profileImage: Data?
    @Published public var registerResult: State = .idle
    
    public init(signUpService: SignUpService) {
        self.signUpService = signUpService
    }
    
    @MainActor public func register() async {
        registerResult = .isLoading
        
        do {
            try RegisterValidator.validate(name: name,
                                           email: email,
                                           password: password,
                                           confirmPassword: confirmPassword)
            
            try await signUp()
        } catch {
            if let error = error as? RegisterValidator.Error {
                registerResult = .failure(error)
            } else if let error = error as? PasswordValidator.Error {
                registerResult = .failure(.passwordError(error))
            }
        }
    }
    
    @MainActor private func signUp() async throws {
        do {
            try await signUpService.signUp(name: name,
                                           email: email,
                                           password: password,
                                           confirmPassword: confirmPassword,
                                           profileImage: profileImage)
            registerResult = .success
        } catch {
            throw RegisterValidator.Error.serverError
        }
    }
}

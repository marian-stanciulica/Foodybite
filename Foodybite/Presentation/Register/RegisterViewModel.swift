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
    private let validator = RegisterValidator()
    
    public enum RegisterResult: Equatable {
        case notTriggered
        case success
        case failure(String)
    }
    
    @Published public var name = ""
    @Published public var email = ""
    @Published public var password = ""
    @Published public var confirmPassword = ""
    @Published public var registerResult: RegisterResult = .notTriggered
    
    public init(signUpService: SignUpService) {
        self.signUpService = signUpService
    }
    
    public func register() async throws {
        try validator.validate(name: name,
                               email: email,
                               password: password,
                               confirmPassword: confirmPassword)

        try await signUpService.signUp(name: name,
                                       email: email,
                                       password: password,
                                       confirmPassword: confirmPassword)
        registerResult = .success
    }
}

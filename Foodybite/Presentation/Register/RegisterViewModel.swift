//
//  RegisterViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation
import FoodybiteNetworking

public class RegisterViewModel {
    private let signUpService: SignUpService
    private let validator = RegisterValidator()
    
    public var name = ""
    public var email = ""
    public var password = ""
    public var confirmPassword = ""
    
    public init(apiService: SignUpService) {
        self.signUpService = apiService
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
    }
}

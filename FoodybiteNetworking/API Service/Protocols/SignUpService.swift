//
//  SignUpService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 12.11.2022.
//

public protocol SignUpService {
    func signUp(name: String, email: String, password: String, confirmPassword: String) async throws
}

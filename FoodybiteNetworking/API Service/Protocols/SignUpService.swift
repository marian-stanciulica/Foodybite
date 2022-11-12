//
//  SignUpService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 12.11.2022.
//

protocol SignUpService {
    func signUp(name: String, email: String, password: String, confirmPassword: String) async throws
}

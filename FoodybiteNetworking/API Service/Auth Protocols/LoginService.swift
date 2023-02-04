//
//  LoginService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import DomainModels

public protocol LoginService {
    func login(email: String, password: String) async throws -> User
}

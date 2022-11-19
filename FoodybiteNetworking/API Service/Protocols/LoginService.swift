//
//  LoginService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

public protocol LoginService {
    func login(email: String, password: String) async throws -> RemoteUser
}

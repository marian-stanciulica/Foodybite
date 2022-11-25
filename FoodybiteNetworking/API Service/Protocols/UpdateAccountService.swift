//
//  UpdateAccountService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation

public protocol UpdateAccountService {
    func updateAccount(name: String, email: String, profileImage: Data?) async throws
    func deleteAccount() async throws
}

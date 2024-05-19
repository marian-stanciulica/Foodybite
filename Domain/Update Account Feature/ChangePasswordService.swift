//
//  ChangePasswordService.swift
//  Domain
//
//  Created by Marian Stanciulica on 24.11.2022.
//

public protocol ChangePasswordService: Sendable {
    func changePassword(currentPassword: String, newPassword: String) async throws
}

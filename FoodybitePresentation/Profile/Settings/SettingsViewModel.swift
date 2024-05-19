//
//  SettingsViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Foundation
import Domain

public final class SettingsViewModel {
    private let logoutService: LogoutService
    private let goToLogin: () -> Void

    public init(logoutService: LogoutService, goToLogin: @escaping () -> Void) {
        self.logoutService = logoutService
        self.goToLogin = goToLogin
    }

    @MainActor
    public func logout() async {
        do {
            try await logoutService.logout()
        } catch {}

        goToLogin()
    }

}

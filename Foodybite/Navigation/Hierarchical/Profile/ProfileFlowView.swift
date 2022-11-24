//
//  ProfileFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import SwiftUI

struct ProfileFlowView: View {
    @ObservedObject var flow: ProfileFlow
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            ProfileView {
                flow.append(.settings)
            }
            .navigationDestination(for: ProfileFlow.Route.self) { route in
                switch route {
                case .settings:
                    SettingsView() {
                        flow.append(.changePassword)
                    }
                case .changePassword:
                    ChangePasswordView()
                }
            }
        }
    }
}

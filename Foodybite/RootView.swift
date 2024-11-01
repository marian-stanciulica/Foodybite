//
//  RootView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import SwiftUI
import Domain
import FoodybitePresentation
import FoodybiteLocation
import FoodybiteUI

struct RootView: View {
    private let rootFactory = RootFactory()
    @State var user: User?
    @AppStorage("loggedInUserID") var loggedInUserID: String?
    @StateObject var authflow = Flow<AuthRoute>()

    var body: some View {
        HStack {
            if let user = user, loggedInUserID != nil {
                UserAuthenticatedView(
                    loggedInUserID: $loggedInUserID,
                    user: user
                )
            } else {
                makeAuthFlowView(loginService: rootFactory.apiService,
                                 signUpService: rootFactory.apiService) { user in
                    Task {
                        self.user = user
                        self.loggedInUserID = user.id.uuidString
                        try? await RootFactory.localStore.write(user)
                    }
                }
            }
        }
        .task {
            if let loggedInUserID = loggedInUserID, let userID = UUID(uuidString: loggedInUserID) {
                user = try? await rootFactory.userDAO.getUser(id: userID)
            }
        }
    }

    @ViewBuilder private func makeAuthFlowView(
        loginService: LoginService,
        signUpService: SignUpService,
        goToMainTab: @escaping (User) -> Void)
    -> some View {
        NavigationStack(path: $authflow.path) {
            AuthFlowView.makeLoginView(
                flow: authflow,
                loginService: loginService,
                goToMainTab: goToMainTab
            )
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .signUp:
                    makeRegisterView(signUpService: signUpService)
                }
            }
        }
    }

    @ViewBuilder private func makeRegisterView(signUpService: SignUpService) -> some View {
        RegisterView(viewModel: RegisterViewModel(signUpService: signUpService)) {
            authflow.navigateBack()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

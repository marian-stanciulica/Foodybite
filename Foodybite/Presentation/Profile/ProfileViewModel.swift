//
//  ProfileViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation
import Domain

public final class ProfileViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case accountDeletionError = "An error occured during deletion. Please try again!"
    }
    
    public enum State: Equatable {
        case isLoading
        case loadingError(String)
        case requestSucceeeded([Review])
    }
    
    private let accountService: AccountService
    private let getReviewsService: GetReviewsService
    private let goToLogin: () -> Void
    let user: User

    @Published public var getReviewsState: State = .isLoading
    @Published public var error: Error?
    
    public init(accountService: AccountService, getReviewsService: GetReviewsService, user: User, goToLogin: @escaping () -> Void) {
        self.accountService = accountService
        self.getReviewsService = getReviewsService
        self.user = user
        self.goToLogin = goToLogin
    }
    
    @MainActor public func deleteAccount() async {
        do {
            try await accountService.deleteAccount()
            goToLogin()
        } catch {
            self.error = Error.accountDeletionError
        }
    }
    
    @MainActor public func getAllReviews() async {
        do {
            let reviews = try await getReviewsService.getReviews(placeID: nil)
            getReviewsState = .requestSucceeeded(reviews)
        } catch {
            getReviewsState = .loadingError("An error occured while fetching reviews. Please try again later!")
        }
    }
}

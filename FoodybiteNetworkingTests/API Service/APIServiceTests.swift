//
//  APIServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import XCTest
import DomainModels
@testable import FoodybiteNetworking

final class APIServiceTests: XCTestCase {
    
    // MARK: - LoginService Tests
    
    func test_conformsToLoginService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as LoginService)
    }
    
    func test_login_loginParamsUsedToCreateEndpoint() async throws {
        let email = anyEmail()
        let password = anyPassword()
        
        let (sut, loader, _, _) = makeSUT(response: anyLoginResponse().response)
        let loginEndpoint = ServerEndpoint.login(LoginRequest(email: email, password: password))
        let urlRequest = try loginEndpoint.createURLRequest()
        
        _ = try await sut.login(email: email, password: password)
        
        let firstRequest = loader.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_login_usesLoginEndpointToCreateURLRequest() async throws {
        let email = anyEmail()
        let password = anyPassword()
        
        let (sut, loader, _, _) = makeSUT(response: anyLoginResponse().response)
        let loginEndpoint = ServerEndpoint.login(LoginRequest(email: email, password: password))
        let urlRequest = try loginEndpoint.createURLRequest()
        
        _ = try await sut.login(email: email, password: password)
        
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_login_receiveExpectedLoginResponse() async throws {
        let (response, expectedModel) = anyLoginResponse()
        let (sut, _, _, _) = makeSUT(response: response)
        
        let receivedResponse = try await sut.login(email: anyEmail(), password: anyPassword())
        
        XCTAssertEqual(expectedModel, receivedResponse)
    }
    
    func test_login_storesAuthTokenInKeychain() async throws {
        let (sut, _, _, tokenStoreStub) = makeSUT(response: anyLoginResponse().response)
        
        _ = try await sut.login(email: anyEmail(), password: anyPassword())
        let receivedToken = try tokenStoreStub.read()
        
        XCTAssertEqual(receivedToken, anyAuthToken())
    }
    
    // MARK: - SignUpService Tests
    
    func test_conformsToSignUpService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as SignUpService)
    }
    
    func test_signUp_paramsUsedToCreateEndpoint() async throws {
        let name = anyName()
        let email = anyEmail()
        let password = anyPassword()
        let confirmPassword = anyPassword()
        let profileImage = anyData()
        
        let (sut, _, sender, _) = makeSUT()
        let signUpEndpoint = ServerEndpoint.signup(SignUpRequest(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: anyData()))
        let urlRequest = try signUpEndpoint.createURLRequest()
        
        try await sut.signUp(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: profileImage)
        
        let firstRequest = sender.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_signUp_usesSignUpEndpointToCreateURLRequest() async throws {
        let name = anyName()
        let email = anyEmail()
        let password = anyPassword()
        let confirmPassword = anyPassword()
        let profileImage = anyData()
        
        let (sut, _, sender, _) = makeSUT()
        let signUpEndpoint = ServerEndpoint.signup(SignUpRequest(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: profileImage))
        let urlRequest = try signUpEndpoint.createURLRequest()
        
        try await sut.signUp(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: profileImage)

        XCTAssertEqual(sender.requests, [urlRequest])
    }
    
    // MARK: - ChangePasswordService Tests
    
    func test_conformsToChangePasswordService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as ChangePasswordService)
    }
    
    func test_changePassword_paramsUsedToCreateEndpoint() async throws {
        let currentPassword = anyPassword()
        let newPassword = anyPassword()
        let confirmPassword = newPassword
        
        let (sut, _, sender, _) = makeSUT()
        let changePasswordEndpoint = ServerEndpoint.changePassword(ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword))
        let urlRequest = try changePasswordEndpoint.createURLRequest()
        
        try await sut.changePassword(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
        
        let firstRequest = sender.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_changePassword_usesChangePasswordEndpointToCreateURLRequest() async throws {
        let currentPassword = anyPassword()
        let newPassword = anyPassword()
        let confirmPassword = newPassword
        
        let (sut, _, sender, _) = makeSUT()
        let changePasswordEndpoint = ServerEndpoint.changePassword(ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword))
        let urlRequest = try changePasswordEndpoint.createURLRequest()
        
        try await sut.changePassword(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)

        XCTAssertEqual(sender.requests, [urlRequest])
    }
    
    // MARK: - LogoutService Tests
    
    func test_conformsToLogoutService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as LogoutService)
    }
    
    func test_logout_usesLogoutEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()
        let logoutEndpoint = ServerEndpoint.logout
        let urlRequest = try logoutEndpoint.createURLRequest()
        
        try await sut.logout()

        XCTAssertEqual(sender.requests, [urlRequest])
    }
    
    // MARK: - AccountService Tests
    
    func test_conformsToUpdateAccountService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as AccountService)
    }
    
    func test_updateAccount_paramsUsedToCreateEndpoint() async throws {
        let name = anyName()
        let email = anyEmail()
        let profileImage = anyData()
        
        let (sut, _, sender, _) = makeSUT()
        let changePasswordEndpoint = ServerEndpoint.updateAccount(UpdateAccountRequest(name: name, email: email, profileImage: profileImage))
        let urlRequest = try changePasswordEndpoint.createURLRequest()
        
        try await sut.updateAccount(name: name, email: email, profileImage: profileImage)
        
        let firstRequest = sender.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_updateAccount_usesUpdateAccountEndpointToCreateURLRequest() async throws {
        let name = anyName()
        let email = anyEmail()
        let profileImage = anyData()
        
        let (sut, _, sender, _) = makeSUT()
        let changePasswordEndpoint = ServerEndpoint.updateAccount(UpdateAccountRequest(name: name, email: email, profileImage: profileImage))
        let urlRequest = try changePasswordEndpoint.createURLRequest()
        
        try await sut.updateAccount(name: name, email: email, profileImage: profileImage)

        XCTAssertEqual(sender.requests, [urlRequest])
    }
    
    func test_deleteAccount_usesDeleteAccountEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()
        let logoutEndpoint = ServerEndpoint.deleteAccount
        let urlRequest = try logoutEndpoint.createURLRequest()
        
        try await sut.deleteAccount()

        XCTAssertEqual(sender.requests, [urlRequest])
    }
    
    // MARK: - ReviewService Tests
    
    func test_conformsToReviewService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as ReviewService)
    }
    
    func test_addReview_paramsUsedToCreateEndpoint() async throws {
        let placeID = anyPlaceID()
        let reviewText = anyReviewText()
        let starsNumber = anyStarsNumber()
        
        let (sut, _, sender, _) = makeSUT()
        let addReviewEndpoint = ReviewEndpoint.addReview(AddReviewRequest(placeID: placeID, text: reviewText, stars: starsNumber))
        let urlRequest = try addReviewEndpoint.createURLRequest()
        
        try await sut.addReview(placeID: placeID, reviewText: reviewText, starsNumber: starsNumber)
        
        let firstRequest = sender.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_addReview_usesAddReviewEndpointToCreateURLRequest() async throws {
        let placeID = anyPlaceID()
        let reviewText = anyReviewText()
        let starsNumber = anyStarsNumber()
        
        let (sut, _, sender, _) = makeSUT()
        let addReviewEndpoint = ReviewEndpoint.addReview(AddReviewRequest(placeID: placeID, text: reviewText, stars: starsNumber))
        let urlRequest = try addReviewEndpoint.createURLRequest()
        
        try await sut.addReview(placeID: placeID, reviewText: reviewText, starsNumber: starsNumber)

        XCTAssertEqual(sender.requests, [urlRequest])
    }
    
    func test_getReviews_usesGetReviewsEndpointToCreateURLRequest() async throws {
        let (sut, loader, _, _) = makeSUT(response: anyGetReviews().response)
        let getReviewsEndpoint = ReviewEndpoint.getReviews(anyPlaceID())
        let urlRequest = try getReviewsEndpoint.createURLRequest()
        
        _ = try await sut.getReviews(placeID: anyPlaceID())

        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_getReviews_returnsExpectedReviews() async throws {
        let (response, expectedModel) = anyGetReviews()
        let (sut, _, _, _) = makeSUT(response: response)
        
        let receivedResponse = try await sut.getReviews()
        
        XCTAssertEqual(expectedModel, receivedResponse)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(response: Decodable? = nil) -> (sut: APIService, loader: ResourceLoaderSpy, sender: ResourceSenderSpy, tokenStoreStub: TokenStoreStub) {
        let tokenStoreStub = TokenStoreStub()
        let loader = ResourceLoaderSpy(response: response ?? "any decodable")
        let sender = ResourceSenderSpy()
        let sut = APIService(loader: loader, sender: sender, tokenStore: tokenStoreStub)
        return (sut, loader, sender, tokenStoreStub)
    }
    
    private func anyName() -> String {
        "any name"
    }
    
    private func anyEmail() -> String {
        "test@test.com"
    }
    
    private func anyPassword() -> String {
        "123@password$321"
    }
    
    private func anyData() -> Data? {
        "any data".data(using: .utf8)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyReviewText() -> String {
        "any review text"
    }
    
    private func anyStarsNumber() -> Int {
        3
    }
    
    private func anyLoginResponse() -> (response: LoginResponse, model: User) {
        let id = UUID()
        let response = LoginResponse(
            user: RemoteUser(id: id,
                             name: "any name",
                             email: "any@email.com",
                             profileImage: nil,
                             followingCount: 0,
                             followersCount: 0),
            token: anyAuthToken()
        )
        
        let model = User(id: id, name: "any name", email: "any@email.com", profileImage: nil)
        return (response, model)
    }
    
    private func anyGetReviews() -> (response: [RemoteReview], model: [Review]) {
        let response = [
            RemoteReview(profileImageData: anyData(), authorName: "author #1", reviewText: "review Text #1", rating: 3, createdAt: Date()),
            RemoteReview(profileImageData: anyData(), authorName: "author #2", reviewText: "review Text #2", rating: 1, createdAt: Date()),
            RemoteReview(profileImageData: anyData(), authorName: "author #3", reviewText: "review Text #3", rating: 4, createdAt: Date()),
        ]
        
        let formatter = RelativeDateTimeFormatter()
        let model = response.map {
            Review(id: $0.id,
                   profileImageURL: nil,
                   profileImageData: $0.profileImageData,
                   authorName: $0.authorName,
                   reviewText: $0.reviewText,
                   rating: $0.rating,
                   relativeTime: formatter.localizedString(for: $0.createdAt, relativeTo: Date())
            )
        }
        
        return (response, model)
    }
    
    private func anyAuthToken() -> AuthToken {
        AuthToken(accessToken: "any access token",
                         refreshToken: "any refresh token")
    }

}

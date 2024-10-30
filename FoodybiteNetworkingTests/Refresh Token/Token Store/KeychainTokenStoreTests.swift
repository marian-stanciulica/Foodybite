//
//  KeychainTokenStoreTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 16.10.2022.
//

import Testing
@testable import FoodybiteNetworking

@Suite(.serialized)
final class KeychainTokenStoreTests {

    init() {
        try? makeSut().delete()
    }

    deinit {
        try? makeSut().delete()
    }

    // MARK: - Tests

    @Test func read_shouldThrowWhenNoTokenInStore() {
        #expect(throws: KeychainTokenStore.Error.notFound) {
            try makeSut().read()
        }
    }

    @Test func write_shouldNotThrowError() {
        #expect(throws: Never.self) {
            try writeDefaultToken(using: makeSut())
        }
    }

    @Test func read_shouldDeliverTokenAfterWrite() throws {
        let expectedToken = AuthToken(accessToken: "access token",
                                      refreshToken: "refresh_token")
        try verifyWriteRead(given: makeSut(), for: expectedToken)
    }

    @Test func write_shouldUpdateValueWhenKeyAlreadyInKeychain() throws {
        let sut = makeSut()

        try writeDefaultToken(using: sut)

        let expectedToken = AuthToken(accessToken: "expected access token",
                                      refreshToken: "expected refresh_token")
        try verifyWriteRead(given: sut, for: expectedToken)
    }

    @Test func write_shouldDeliverTokenAfterWriteUsingAnotherInstance() throws {
        try writeDefaultToken(using: makeSut())

        let expectedToken = AuthToken(accessToken: "expected access token",
                                      refreshToken: "expected refresh_token")
        try verifyWriteRead(given: makeSut(), for: expectedToken)
    }

    // MARK: - Helpers

    private func makeSut() -> KeychainTokenStore {
        let service = "test service"
        let account = "test account"
        return KeychainTokenStore(service: service,
                                  account: account)
    }

    private func writeDefaultToken(using sut: KeychainTokenStore) throws {
        let firstToken = AuthToken(accessToken: "default access token",
                                   refreshToken: "default refresh_token")

        try sut.write(firstToken)
    }

    private func verifyWriteRead(
        given sut: KeychainTokenStore,
        for expectedToken: AuthToken,
        sourceLocation: SourceLocation = #_sourceLocation
    ) throws {
        try sut.write(expectedToken)

        let receivedToken = try sut.read()

        #expect(expectedToken.accessToken == receivedToken.accessToken, sourceLocation: sourceLocation)
        #expect(expectedToken.refreshToken == receivedToken.refreshToken, sourceLocation: sourceLocation)
    }

}

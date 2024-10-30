//
//  UserDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Testing
import Foundation.NSUUID
import Domain
import FoodybitePersistence

struct UserDAOTests {

    @Test func getUser_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())

        do {
            let user = try await sut.getUser(id: UUID())
            Issue.record("Expected to fail, received user \(user) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func getUser_throwsErrorWhenUserNotFound() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readAllResult = .success([makeUser(), makeUser(), makeUser()])

        do {
            let user = try await sut.getUser(id: UUID())
            Issue.record("Expected to fail, received user \(user) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func getUser_returnsFoundUserWhenFoundInStore() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedUser = makeUser()
        storeSpy.readAllResult = .success([makeUser(), makeUser()] + [expectedUser])

        let receivedUser = try await sut.getUser(id: expectedUser.id)
        #expect(expectedUser == receivedUser)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: UserDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = UserDAO(store: storeSpy)
        return (sut, storeSpy)
    }

    private func makeUser() -> User {
        User(id: UUID(), name: "User", email: "user@user.com", profileImage: nil)
    }

}

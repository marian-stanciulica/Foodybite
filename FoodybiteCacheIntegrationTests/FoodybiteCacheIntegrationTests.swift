//
//  FoodybiteCacheIntegrationTests.swift
//  FoodybiteCacheIntegrationTests
//
//  Created by Marian Stanciulica on 06.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class FoodybiteUserCacheIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()

        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()

        undoStoreSideEffects()
    }

    func test_loadUser_deliversNilOnEmptyCache() async throws {
        let localStore = try makeLocalStore()

        let user: User? = try? await localStore.read()

        XCTAssertEqual(user, nil)
    }

    func test_loadUser_deliversUserSavedOnASeparateInstance() async throws {
        let localStoreToPerformSave = try makeLocalStore()
        let localStoreToPerformLoad = try makeLocalStore()
        let user = makeUser()

        try await localStoreToPerformSave.write(user)

        let receivedUser: User = try await localStoreToPerformLoad.read()
        XCTAssertEqual(receivedUser, user)
    }

    func test_saveUser_updatesUserSavedOnASeparateInstance() async throws {
        let localStoreToPerformFirstSave = try makeLocalStore()
        let localStoreToPerformSecondSave = try makeLocalStore()
        let localStoreToPerformLoad = try makeLocalStore()
        let userID = UUID()
        let firstUser = makeUser(id: userID)
        let secondUser = makeUser(id: userID)

        try await localStoreToPerformFirstSave.write(firstUser)
        try await localStoreToPerformSecondSave.write(secondUser)

        let receivedUser: User = try await localStoreToPerformLoad.read()
        XCTAssertEqual(receivedUser, secondUser)
    }

    // MARK: - Helpers

    private func makeLocalStore() throws -> LocalStore {
        let storeURL = testSpecificStoreURL()
        let sut = try CoreDataLocalStore(storeURL: storeURL)
        return sut
    }

    private func makeUser(id: UUID = UUID()) -> User {
        User(id: id, name: "User #1", email: "testing@testing.com", profileImage: nil)
    }

    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
}

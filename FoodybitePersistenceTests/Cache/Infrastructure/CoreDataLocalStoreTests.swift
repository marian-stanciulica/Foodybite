//
//  CoreDataLocalStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import Testing
import Foundation.NSUUID
import Domain
import FoodybitePersistence

struct CoreDataLocalStoreTests {

    @Test func read_deliversErrorOnCacheMiss() async throws {
        let sut = try makeSUT()

        await expectReadToFail(sut: sut)
    }

    @Test func read_hasNoSideEffectsOnCacheMiss() async throws {
        let sut = try makeSUT()

        await expectReadToFailTwice(sut: sut)
    }

    @Test func read_deliversResourceOnCacheHit() async throws {
        let sut = try makeSUT()

        let expectedUser = anyUser()
        try await sut.write(expectedUser)

        await expectReadToSucceed(sut: sut, withExpected: expectedUser)
    }

    @Test func read_hasNoSideEffectsOnCacheHit() async throws {
        let sut = try makeSUT()

        let expectedUser = anyUser()
        try await sut.write(expectedUser)

        await expectReadToSucceedTwice(sut: sut, withExpected: expectedUser)
    }

    @Test func write_deliversNoErrorOnEmptyCache() async throws {
        let sut = try makeSUT()

        do {
            try await sut.write(anyUser())
        } catch {
            Issue.record("Write should succeed on empty cache, got \(error) instead")
        }
    }

    @Test func write_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = try makeSUT()

        try await sut.write(anyUser())

        do {
            try await sut.write(anyUser())
        } catch {
            Issue.record("Write should succeed on non empty cache, got \(error) instead")
        }
    }

    @Test func write_updatesPreviouslyInsertedResource() async throws {
        let sut = try makeSUT()
        let userID = UUID()
        let anyUser = anyUser(id: userID)
        let anotherUser = anotherUser(id: userID)

        try await sut.write(anotherUser)

        try await sut.write(anyUser)
        let receivedUser: User = try await sut.read()

        #expect(receivedUser == anyUser)
    }

    // MARK: - Helpers

    private func makeSUT(storeURL: URL? = nil) throws -> CoreDataLocalStore {
        let storeBundle = Bundle(for: CoreDataLocalStore.self)
        let storeURL = URL(filePath: "/dev/null")
        return try CoreDataLocalStore(storeURL: storeURL, bundle: storeBundle)
    }

    private func expectReadToFail(sut: CoreDataLocalStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        do {
            let _: User = try await sut.read()
            Issue.record("Read method expected to fail when cache miss", sourceLocation: sourceLocation)
        } catch {
            #expect(error != nil, sourceLocation: sourceLocation)
        }
    }

    private func expectReadToFailTwice(sut: CoreDataLocalStore, sourceLocation: SourceLocation = #_sourceLocation) async {
        await expectReadToFail(sut: sut, sourceLocation: sourceLocation)
        await expectReadToFail(sut: sut, sourceLocation: sourceLocation)
    }

    private func expectReadToSucceed(
        sut: CoreDataLocalStore,
        withExpected expectedUser: User,
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        do {
            let receivedResource: User = try await sut.read()
            #expect(receivedResource == expectedUser, sourceLocation: sourceLocation)
        } catch {
            Issue.record("Expected to receive a resource, got \(error) instead", sourceLocation: sourceLocation)
        }
    }

    private func expectReadToSucceedTwice(
        sut: CoreDataLocalStore,
        withExpected expectedUser: User,
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        await expectReadToSucceed(sut: sut, withExpected: expectedUser, sourceLocation: sourceLocation)
        await expectReadToSucceed(sut: sut, withExpected: expectedUser, sourceLocation: sourceLocation)
    }

    private func anyUser(id: UUID = UUID()) -> User {
        return User(id: id, name: "any name", email: "any@email.com", profileImage: nil)
    }

    private func anotherUser(id: UUID = UUID()) -> User {
        return User(id: id, name: "another name", email: "another@email.com", profileImage: nil)
    }

    private func makeReviews() -> [Review] {
        [
            Review(
                restaurantID: "restaurant #1",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #1",
                reviewText: "review text #1",
                rating: 2,
                relativeTime: "1 hour ago"
            ),
            Review(
                restaurantID: "restaurant #2",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #1",
                reviewText: "review text #2",
                rating: 3,
                relativeTime: "one year ago"
            ),
            Review(
                restaurantID: "restaurant #3",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #1",
                reviewText: "review text #3",
                rating: 4,
                relativeTime: "2 months ago"
            )
        ]
    }

}

//
//  CoreDataLocalStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import XCTest
import Domain
import FoodybitePersistence

final class CoreDataLocalStoreTests: XCTestCase {
    
    func test_read_deliversErrorOnCacheMiss() async {
        let sut = makeSUT()

        await expectReadToFail(sut: sut)
    }
    
    func test_read_hasNoSideEffectsOnCacheMiss() async {
        let sut = makeSUT()

        await expectReadToFailTwice(sut: sut)
    }
    
    func test_read_deliversResourceOnCacheHit() async throws {
        let sut = makeSUT()

        let expectedUser = anyUser()
        try await sut.write(expectedUser)

        await expectReadToSucceed(sut: sut, withExpected: expectedUser)
    }
    
    func test_read_hasNoSideEffectsOnCacheHit() async throws {
        let sut = makeSUT()

        let expectedUser = anyUser()
        try await sut.write(expectedUser)

        await expectReadToSucceedTwice(sut: sut, withExpected: expectedUser)
    }
    
    func test_write_deliversNoErrorOnEmptyCache() async {
        let sut = makeSUT()

        do {
            try await sut.write(anyUser())
        } catch {
            XCTFail("Write should succeed on empty cache, got \(error) instead")
        }
    }
    
    func test_write_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()

        try await sut.write(anyUser())

        do {
            try await sut.write(anyUser())
        } catch {
            XCTFail("Write should succeed on non empty cache, got \(error) instead")
        }
    }
    
    func test_write_updatesPreviouslyInsertedResource() async throws {
        let sut = makeSUT()
        let userID = UUID()
        let anyUser = anyUser(id: userID)
        let anotherUser = anotherUser(id: userID)

        try await sut.write(anotherUser)

        try await sut.write(anyUser)
        let receivedUser: User = try await sut.read()

        XCTAssertEqual(receivedUser, anyUser)
    }
    
    func test_getReviews_deliversEmptyArrayOnCacheMiss() async throws {
        let sut = makeSUT()
        
        let receivedReviews = try await sut.getReviews()
        
        XCTAssertTrue(receivedReviews.isEmpty)
    }
    
    func test_getReviews_deliversReviewsOnCacheHit() async throws {
        let sut = makeSUT()
        let expectedReviews = makeReviews()
        try await sut.save(reviews: expectedReviews)
        
        let receivedReviews = try await sut.getReviews()
        
        XCTAssertEqual(receivedReviews, expectedReviews)
    }
    
    func test_getReviews_deliversReviewsForPlaceID() async  throws {
        let sut = makeSUT()
        let allReviews = makeReviews()
        let expectedReviews = [allReviews[1]]
        try await sut.save(reviews: allReviews)
        
        let receivedReviews = try await sut.getReviews(placeID: expectedReviews.first?.placeID)
        
        XCTAssertEqual(receivedReviews, expectedReviews)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil) -> CoreDataLocalStore {
        let storeBundle = Bundle(for: CoreDataLocalStore.self)
        let storeURL = URL(filePath: "/dev/null")
        return try! CoreDataLocalStore(storeURL: storeURL, bundle: storeBundle)
    }

    private func expectReadToFail(sut: CoreDataLocalStore, file: StaticString = #file, line: UInt = #line) async {
        do {
            let _: User = try await sut.read()
            XCTFail("Read method expected to fail when cache miss", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }

    private func expectReadToFailTwice(sut: CoreDataLocalStore, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToFail(sut: sut)
        await expectReadToFail(sut: sut)
    }

    private func expectReadToSucceed(sut: CoreDataLocalStore, withExpected expectedUser: User, file: StaticString = #file, line: UInt = #line) async {
        do {
            let receivedResource: User = try await sut.read()
            XCTAssertEqual(receivedResource, expectedUser, file: file, line: line)
        } catch {
            XCTFail("Expected to receive a resource, got \(error) instead", file: file, line: line)
        }
    }

    private func expectReadToSucceedTwice(sut: CoreDataLocalStore, withExpected expectedUser: User, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToSucceed(sut: sut, withExpected: expectedUser, file: file, line: line)
        await expectReadToSucceed(sut: sut, withExpected: expectedUser, file: file, line: line)
    }

    private func anyUser(id: UUID = UUID()) -> User {
        return User(id: id, name: "any name", email: "any@email.com", profileImage: nil)
    }
    
    private func anotherUser(id: UUID = UUID()) -> User {
        return User(id: id, name: "another name", email: "another@email.com", profileImage: nil)
    }

    private func makeReviews() -> [Review] {
        [
            Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #1", rating: 2, relativeTime: "1 hour ago"),
            Review(placeID: "place #2", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #2", rating: 3, relativeTime: "one year ago"),
            Review(placeID: "place #3", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #3", rating: 4, relativeTime: "2 months ago")
        ]
    }

}

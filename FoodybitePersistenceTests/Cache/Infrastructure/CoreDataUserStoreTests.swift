//
//  CoreDataUserStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import XCTest
import Domain
import FoodybitePersistence

final class CoreDataUserStoreTests: XCTestCase {
    
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
    
    func test_write_overridesPreviouslyInsertedResource() async throws {
        let sut = makeSUT()

        let anyUser = anyUser()
        let anotherUser = anotherUser()

        try await sut.write(anotherUser)

        try await sut.write(anyUser)
        let receivedUser = try await sut.read()

        XCTAssertEqual(receivedUser, anyUser)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() async {
        let sut = makeSUT()

        do {
            try await sut.delete()
        } catch {
            XCTFail("Delete should succeed on empty cache, got \(error) instead")
        }
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = makeSUT()

        try await sut.delete()

        do {
            let result = try await sut.read()
            XCTFail("Expected read to fail, got \(result) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()

        try await sut.write(anyUser())

        do {
            try await sut.delete()
        } catch {
            XCTFail("Delete should succeed on non empty cache, got \(error) instead")
        }
    }
    
    func test_delete_deletesPreviouslyWrittenResource() async throws {
        let sut = makeSUT()

        try await sut.write(anyUser())
        try await sut.delete()

        do {
            let resource = try await sut.read()
            XCTFail("Expected read to fail, got \(resource) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil) -> CoreDataUserStore<User> {
        let storeBundle = Bundle(for: CoreDataUserStore<User>.self)
        let storeURL = URL(filePath: "/dev/null")
        return try! CoreDataUserStore<User>(storeURL: storeURL, bundle: storeBundle)
    }

    private func expectReadToFail(sut: CoreDataUserStore<User>, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.read()
            XCTFail("Read method expected to fail when cache miss", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }

    private func expectReadToFailTwice(sut: CoreDataUserStore<User>, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToFail(sut: sut)
        await expectReadToFail(sut: sut)
    }

    private func expectReadToSucceed(sut: CoreDataUserStore<User>, withExpected expectedUser: User, file: StaticString = #file, line: UInt = #line) async {
        do {
            let receivedResource = try await sut.read()
            XCTAssertEqual(receivedResource, expectedUser, file: file, line: line)
        } catch {
            XCTFail("Expected to receive a resource, got \(error) instead", file: file, line: line)
        }
    }

    private func expectReadToSucceedTwice(sut: CoreDataUserStore<User>, withExpected expectedUser: User, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToSucceed(sut: sut, withExpected: expectedUser, file: file, line: line)
        await expectReadToSucceed(sut: sut, withExpected: expectedUser, file: file, line: line)
    }

    private func anyUser() -> User {
        return User(id: UUID(), name: "any name", email: "any@email.com", profileImage: nil)
    }

    private func anotherUser() -> User {
        return User(id: UUID(), name: "another name", email: "another@email.com", profileImage: nil)
    }

}

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
    
    // MARK: - LocalStore Tests
    
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
        let receivedUser: User = try await sut.read()

        XCTAssertEqual(receivedUser, anyUser)
    }
    
    // MARK: - LocalPhotoDataStore Tests
    
    func test_readData_deliversErrorOnCacheMiss() async {
        let sut = makeSUT()

        await expectReadDataToFail(sut: sut)
    }
    
    func test_readData_deliversPhotoDataOnCacheHit() async throws {
        let sut = makeSUT()
        let photoReference = "photo reference"
        let expectedPhotoData = "photo data".data(using: .utf8)!
        try await sut.write(Photo(width: 1, height: 1, photoReference: photoReference))
        try await sut.write(photoData: expectedPhotoData, for: photoReference)

        await expectReadDataToSucceed(sut: sut, for: photoReference, withExpected: expectedPhotoData)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil) -> CoreDataLocalStore {
        let storeBundle = Bundle(for: CoreDataLocalStore.self)
        let storeURL = URL(filePath: "/dev/null")
        return try! CoreDataLocalStore(storeURL: storeURL, bundle: storeBundle)
    }

    // MARK: - LocalStore Helpers
    
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

    private func anyUser() -> User {
        return User(id: UUID(), name: "any name", email: "any@email.com", profileImage: nil)
    }

    private func anotherUser() -> User {
        return User(id: UUID(), name: "another name", email: "another@email.com", profileImage: nil)
    }
    
    // MARK: - LocalPhotoDataStore Helpers
    
    private func expectReadDataToFail(sut: CoreDataLocalStore, file: StaticString = #file, line: UInt = #line) async {
        do {
            let _: Data = try await sut.read(photoReference: "reference")
            XCTFail("Read method expected to fail when cache miss", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }
    
    private func expectReadDataToSucceed(sut: CoreDataLocalStore, for photoReference: String, withExpected expectedPhotoData: Data, file: StaticString = #file, line: UInt = #line) async {
        do {
            let receivedPhotoData: Data = try await sut.read(photoReference: photoReference)
            XCTAssertEqual(receivedPhotoData, expectedPhotoData, file: file, line: line)
        } catch {
            XCTFail("Expected to receive a resource, got \(error) instead", file: file, line: line)
        }
    }

}

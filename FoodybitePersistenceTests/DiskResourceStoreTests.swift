//
//  DiskResourceStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import XCTest
import FoodybitePersistence

final class DiskResourceStoreTests: XCTestCase, FailableUserStoreSpecs {

    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_read_deliversErrorOnCacheMiss() async {
        let sut = makeSUT()
        
        await assertThatReadDeliversErrorOnCacheMiss(on: sut)
    }
    
    func test_read_hasNoSideEffectsOnCacheMiss() async {
        let sut = makeSUT()
        
        await assertThatReadHasNoSideEffectsOnCacheMiss(on: sut)
    }
    
    func test_read_deliversResourceOnCacheHit() async throws {
        let sut = makeSUT()
        
        try await assertThatReadDeliversResourceOnCacheHit(on: sut)
    }
    
    func test_read_hasNoSideEffectsOnCacheHit() async throws {
        let sut = makeSUT()
        
        try await assertThatReadHasNoSideEffectsOnCacheHit(on: sut)
    }
    
    func test_read_deliversErrorOnInvalidData() async throws {
        let sut = makeSUT()
        
        try await assertThatReadDeliversErrorOnInvalidData(on: sut)
    }
    
    func test_read_hasNoSideEffectOnFailure() async throws {
        let sut = makeSUT()
        
        try await assertThatReadHasNoSideEffectsOnFailure(on: sut)
    }
    
    func test_write_deliversNoErrorOnEmptyCache() async {
        let sut = makeSUT()
        
        await assertThatWriteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_write_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()
        
        try await assertThatWriteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_write_overridesPreviouslyInsertedResource() async throws {
        let sut = makeSUT()
        
        try await assertThatWriteOverridesPreviouslyInsertedUser(on: sut)
    }
    
    func test_write_deliversErrorOnWriteError() async {
        let sut = makeSUT(storeURL: invalidStoreURL())
        
        await assertThatWriteDeliversErrorOnWriteError(on: sut)
    }
    
    func test_write_hasNoSideEffectsOnWriteError() async {
        let sut = makeSUT(storeURL: invalidStoreURL())
        
        await assertThatWriteHasNoSideEffectsOnWriteError(on: sut)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() async {
        let sut = makeSUT()
        
        await assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = makeSUT()
        
        try await assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
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
    
    func test_delete_hasNoSideEffectsOnDeleteError() async throws {
        let sut = makeSUT(storeURL: invalidStoreURL())
        
        try await sut.delete()
        
        do {
            let result = try await sut.read()
            XCTFail("Expected read to fail, got \(result) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil) -> UserStore {
        return UserDiskStore(storeURL: storeURL ?? testSpecificStoreURL())
    }
    
    private func expectReadToFailTwice(sut: UserStore, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToFail(sut: sut)
        await expectReadToFail(sut: sut)
    }
    
    private func expectReadToFail(sut: UserStore, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.read()
            XCTFail("Read method expected to fail when cache miss", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }
    
    private func expectReadToSucceedTwice(sut: UserStore, withExpected expectedUser: LocalUser, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.read()
            let receivedResource = try await sut.read()
            XCTAssertEqual(receivedResource, expectedUser, file: file, line: line)
        } catch {
            XCTFail("Expected to receive a resource, got \(error) instead", file: file, line: line)
        }
    }
    
    private func expectReadToSucceed(sut: UserStore, withExpected expectedUser: LocalUser, file: StaticString = #file, line: UInt = #line) async {
        do {
            let receivedResource = try await sut.read()
            XCTAssertEqual(receivedResource, expectedUser, file: file, line: line)
        } catch {
            XCTFail("Expected to receive a resource, got \(error) instead", file: file, line: line)
        }
    }
    
    private func writeInvalidData() async throws {
        let invalidData = "invalid data".data(using: .utf8)
        try invalidData?.write(to: resourceSpecificURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
    }
    
    private func invalidStoreURL() -> URL {
        return FileManager.default
            .urls(for: .adminApplicationDirectory, in: .userDomainMask)
            .first!
    }
    
    private func resourceSpecificURL() -> URL {
        return testSpecificStoreURL()
            .appending(path: "User.resource")
    }
    
    private func anyUser() -> LocalUser {
        return LocalUser(id: UUID(), name: "any name", email: "any@email.com", profileImage: URL(string: "http://any.com")!)
    }
    
    private func anotherUser() -> LocalUser {
        return LocalUser(id: UUID(), name: "another name", email: "another@email.com", profileImage: URL(string: "http://another.com")!)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: resourceSpecificURL())
    }
   
}

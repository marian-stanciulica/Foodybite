//
//  DiskUserStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import XCTest
import FoodybitePersistence

final class DiskUserStoreTests: XCTestCase, FailableUserStoreSpecs {

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
        
        try await assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_delete_deletesPreviouslyWrittenResource() async throws {
        let sut = makeSUT()
        
        try await assertThatDeleteDeletesPreviouslyWrittenUser(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnDeleteError() async throws {
        let sut = makeSUT(storeURL: invalidStoreURL())
        
        try await assertThatDeleteHasNoSideEffectsOnDeleteError(on: sut)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil) -> UserStore {
        return DiskUserStore(storeURL: storeURL ?? testSpecificStoreURL())
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
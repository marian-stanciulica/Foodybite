//
//  RealmUserStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

import XCTest
import FoodybitePersistence

final class RealmUserStoreTests: XCTestCase, UserStoreSpecs {
    
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
//        let sut = makeSUT()
//
//        try await assertThatReadHasNoSideEffectsOnCacheHit(on: sut)
    }
    
    func test_write_deliversNoErrorOnEmptyCache() async {
//        let sut = makeSUT()
//
//        await assertThatWriteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_write_deliversNoErrorOnNonEmptyCache() async throws {
//        let sut = makeSUT()
//
//        try await assertThatWriteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_write_overridesPreviouslyInsertedResource() async throws {
//        let sut = makeSUT()
//
//        try await assertThatWriteOverridesPreviouslyInsertedUser(on: sut)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() async {
//        let sut = makeSUT()
//
//        await assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws {
//        let sut = makeSUT()
//
//        try await assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws {
//        let sut = makeSUT()
//
//        try await assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_delete_deletesPreviouslyWrittenResource() async throws {
//        let sut = makeSUT()
//
//        try await assertThatDeleteDeletesPreviouslyWrittenUser(on: sut)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil) -> UserStore {
        return try! RealmUserStore(inMemoryIdentifier: "\(type(of: self))")
    }

}

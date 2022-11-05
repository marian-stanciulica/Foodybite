//
//  UserStoreSpecs.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 05.11.2022.
//

protocol UserStoreSpecs {
    func test_read_deliversErrorOnCacheMiss() async
    func test_read_hasNoSideEffectsOnCacheMiss() async
    func test_read_deliversResourceOnCacheHit() async throws
    func test_read_hasNoSideEffectsOnCacheHit() async throws
    
    func test_write_deliversNoErrorOnEmptyCache() async
    func test_write_deliversNoErrorOnNonEmptyCache() async throws
    func test_write_overridesPreviouslyInsertedResource() async throws
    
    func test_delete_deliversNoErrorOnEmptyCache() async
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws
    func test_delete_deletesPreviouslyWrittenResource() async throws
}

protocol FailableReadUserStoreSpecs: UserStoreSpecs {
    func test_read_deliversErrorOnInvalidData() async throws
    func test_read_hasNoSideEffectOnFailure() async throws
}

protocol FailableWriteUserStoreSpecs: UserStoreSpecs {
    func test_write_deliversErrorOnWriteError() async
    func test_write_hasNoSideEffectsOnWriteError() async throws
}

protocol FailableDeleteUserStoreSpecs: UserStoreSpecs {
    func test_delete_hasNoSideEffectsOnDeleteError() async throws
}

protocol FailableUserStoreSpecs: FailableReadUserStoreSpecs, FailableWriteUserStoreSpecs, FailableDeleteUserStoreSpecs {}

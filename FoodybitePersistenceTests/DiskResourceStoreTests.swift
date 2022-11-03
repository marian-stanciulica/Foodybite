//
//  DiskResourceStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import XCTest

class DiskResourceStore<T> {
    private let storeURL: URL
    
    private struct CacheMissError: Error {}
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func read() async throws -> T {
        throw CacheMissError()
    }
    
}

final class DiskResourceStoreTests: XCTestCase {

    func test_read_deliversErrorOnCacheMiss() async {
        let sut = makeSUT()
        
        do {
            _ = try await sut.read()
            XCTFail("Read method expected to fail when cache miss")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_read_hasNoSideEffectsOnCacheMiss() async {
        let sut = makeSUT()
        
        do {
            _ = try await sut.read()
            XCTFail("Read method expected to fail when cache miss")
        } catch {
            XCTAssertNotNil(error)
        }
        
        do {
            _ = try await sut.read()
            XCTFail("Read method expected to fail when cache miss")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> DiskResourceStore<TestingResource> {
        return DiskResourceStore<TestingResource>(storeURL: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("\(type(of: self)).store")
    }
    
    private struct TestingResource {
        let resource = "any resource"
    }
   
}

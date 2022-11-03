//
//  DiskResourceStoreTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 03.11.2022.
//

import XCTest

class DiskResourceStore<T: Codable> {
    private let storeURL: URL
    
    private struct CacheMissError: Error {}
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func read() async throws -> T {
        guard let data = try? Data(contentsOf: storeURL) else {
            throw CacheMissError()
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    func write(_ object: T) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        try data.write(to: storeURL)
    }
    
    func delete(_ type: T.Type) async throws {
        
    }
}

final class DiskResourceStoreTests: XCTestCase {

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
        
        await expectReadToFail(sut: sut)
    }
    
    func test_read_hasNoSideEffectsOnCacheMiss() async {
        let sut = makeSUT()
        
        await expectReadToFail(sut: sut)
        await expectReadToFail(sut: sut)
    }
    
    func test_read_deliverResourceOnCacheHit() async throws {
        let sut = makeSUT()
        let expectedResource = anyResource()
        
        try await sut.write(expectedResource)
        let receivedResource = try await sut.read()
        
        XCTAssertEqual(receivedResource, expectedResource)
    }
    
    func test_read_hasNoSideEffectsOnCacheHit() async throws {
        let sut = makeSUT()
        let expectedResource = anyResource()
        
        try await sut.write(expectedResource)
        _ = try await sut.read()
        let receivedResource = try await sut.read()
        
        XCTAssertEqual(receivedResource, expectedResource)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> DiskResourceStore<TestingResource> {
        return DiskResourceStore<TestingResource>(storeURL: testSpecificStoreURL())
    }
    
    private func expectReadToFail(sut: DiskResourceStore<TestingResource>, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.read()
            XCTFail("Read method expected to fail when cache miss", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("\(type(of: self)).store")
    }
    
    private func anyResource() -> TestingResource {
        return TestingResource(resource: "any resource")
    }
    
    private struct TestingResource: Codable, Equatable {
        let resource: String
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

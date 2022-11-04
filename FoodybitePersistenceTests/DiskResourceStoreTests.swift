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
        self.storeURL = storeURL.appending(path: "\(T.self).resource")
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
        if FileManager.default.fileExists(atPath: storeURL.path()) {
            try FileManager.default.removeItem(at: storeURL)
        }
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
        
        await expectReadToFailTwice(sut: sut)
    }
    
    func test_read_deliverResourceOnCacheHit() async throws {
        let sut = makeSUT()
        let expectedResource = anyResource()
        try await sut.write(expectedResource)
        
        await expectReadToSucceed(sut: sut, withExpected: expectedResource)
    }
    
    func test_read_hasNoSideEffectsOnCacheHit() async throws {
        let sut = makeSUT()
        let expectedResource = anyResource()
        try await sut.write(expectedResource)
        
        await expectReadToSucceedTwice(sut: sut, withExpected: expectedResource)
    }
    
    func test_read_deliversErrorOnInvalidData() async {
        let sut = makeSUT()
        let invalidData = "invalid data".data(using: .utf8)
        try! invalidData?.write(to: resourceSpecificURL())
        
        await expectReadToFail(sut: sut)
    }
    
    func test_read_hasNoSideEffectOnFailure() async {
        let sut = makeSUT()
        let invalidData = "invalid data".data(using: .utf8)
        try! invalidData?.write(to: resourceSpecificURL())
        
        await expectReadToFailTwice(sut: sut)
    }
    
    func test_write_deliversNoErrorOnEmptyCache() async {
        let sut = makeSUT()
        
        do {
            try await sut.write(anyResource())
        } catch {
            XCTFail("Write should succeed on empty cache, got \(error) instead")
        }
    }
    
    func test_write_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()
        try await sut.write(anyResource())
        
        do {
            try await sut.write(anyResource())
        } catch {
            XCTFail("Write should succeed on non empty cache, got \(error) instead")
        }
    }
    
    func test_write_overridesPreviouslyInsertedResource() async throws {
        let sut = makeSUT()
        try await sut.write(TestingResource(resource: "another resource"))
        
        try await sut.write(anyResource())
        let receivedResource = try await sut.read()
        
        XCTAssertEqual(receivedResource, anyResource())
    }
    
    func test_write_deliversErrorOnWriteError() async {
        let sut = makeSUT(storeURL: invalidStoreURL())
        
        do {
            try await sut.write(anyResource())
            XCTFail("Expected write method to fail")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_write_hasNoSideEffectsOnWriteError() async {
        let sut = makeSUT(storeURL: invalidStoreURL())
        
        try? await sut.write(anyResource())
        
        do {
            let result = try await sut.read()
            XCTFail("Expected read to deliver no result, got \(result) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() async {
        let sut = makeSUT()
        
        do {
            try await sut.delete(TestingResource.self)
        } catch {
            XCTFail("Delete should succeed on empty cache, got \(error) instead")
        }
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = makeSUT()
        
        try await sut.delete(TestingResource.self)
        
        do {
            let result = try await sut.read()
            XCTFail("Expected read to deliver no result, got \(result) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()
        
        try await sut.write(anyResource())
        
        do {
            try await sut.delete(TestingResource.self)
        } catch {
            XCTFail("Delete should succeed on non empty cache, got \(error) instead")
        }
    }
    
    func test_delete_deletesPreviouslyWrittenResource() async throws {
        let sut = makeSUT()
        
        try await sut.write(anyResource())
        try await sut.delete(TestingResource.self)
        
        do {
            let resource = try await sut.read()
            XCTFail("Read should fail on empty cache, got \(resource) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_delete_hasNoSideEffectsOnDeleteError() async {
        let sut = makeSUT(storeURL: invalidStoreURL())
        
        try? await sut.delete(TestingResource.self)
        
        do {
            let result = try await sut.read()
            XCTFail("Expected read to deliver no result, got \(result) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil) -> DiskResourceStore<TestingResource> {
        return DiskResourceStore<TestingResource>(storeURL: storeURL ?? testSpecificStoreURL())
    }
    
    private func expectReadToFailTwice(sut: DiskResourceStore<TestingResource>, file: StaticString = #file, line: UInt = #line) async {
        await expectReadToFail(sut: sut)
        await expectReadToFail(sut: sut)
    }
    
    private func expectReadToFail(sut: DiskResourceStore<TestingResource>, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.read()
            XCTFail("Read method expected to fail when cache miss", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }
    
    private func expectReadToSucceedTwice(sut: DiskResourceStore<TestingResource>, withExpected expectedResource: TestingResource, file: StaticString = #file, line: UInt = #line) async {
        do {
            _ = try await sut.read()
            let receivedResource = try await sut.read()
            XCTAssertEqual(receivedResource, expectedResource, file: file, line: line)
        } catch {
            XCTFail("Expected to receive a resource, got \(error) instead", file: file, line: line)
        }
    }
    
    private func expectReadToSucceed(sut: DiskResourceStore<TestingResource>, withExpected expectedResource: TestingResource, file: StaticString = #file, line: UInt = #line) async {
        do {
            let receivedResource = try await sut.read()
            XCTAssertEqual(receivedResource, expectedResource, file: file, line: line)
        } catch {
            XCTFail("Expected to receive a resource, got \(error) instead", file: file, line: line)
        }
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
            .appending(path: "\(TestingResource.self).resource")
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

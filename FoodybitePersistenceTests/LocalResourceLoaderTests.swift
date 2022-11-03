//
//  LocalResourceLoaderTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 29.10.2022.
//

import XCTest

class LocalResourceLoader<T> {
    private let client: ResourceStoreSpy<T>
    
    init(client: ResourceStoreSpy<T>) {
        self.client = client
    }
    
    func load() async throws -> T {
        return try await client.read()
    }
    
    func save(object: T) async throws {
        try await client.delete(T.self)
        try await client.write()
    }
    
}

class ResourceStoreSpy<T> {
    enum Message {
        case read
        case write
        case delete
    }
    
    struct CompletionNotSet: Error {}
    
    private(set) var messages = [Message]()
    
    private(set) var readResult: Result<T, Error>?
    private(set) var writeError: Error? = nil
    private(set) var deleteError: Error? = nil
    
    func read() async throws -> T {
        messages.append(.read)
        
        if let readCompletion = readResult {
            return try readCompletion.get()
        } else {
            throw CompletionNotSet()
        }
    }
    
    func setRead(error: Error) {
        readResult = .failure(error)
    }
    
    func setRead(returnedObject object: T) {
        readResult = .success(object)
    }
    
    func write() async throws {
        messages.append(.write)
        
        if let writeError = writeError {
            throw writeError
        }
    }
    
    func setWrite(error: Error?) {
        writeError = error
    }
    
    func delete(_ type: T.Type) async throws {
        messages.append(.delete)
        
        if let deleteError = deleteError {
            throw deleteError
        }
    }
    
    func setDeletion(error: Error?) {
        deleteError = error
    }
}

final class LocalResourceLoaderTests: XCTestCase {

    func test_init_doesNotReceiveMessagesUponCreation() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.messages, [])
    }
    
    func test_load_callClientRead() async {
        let (sut, client) = makeSUT()
        
        _ = try? await sut.load()
        
        XCTAssertEqual(client.messages, [.read])
    }
    
    func test_load_returnsErrorOnClientError() async {
        let (sut, client) = makeSUT()
        
        let expectedError = anyNSError()
        client.setRead(error: expectedError)
        
        await expectLoad(sut, toCompleteWith: .failure(expectedError))
    }
    
    func test_load_returnsObjectSuccessfullyOnClientSuccess() async {
        let (sut, client) = makeSUT()
        
        let expectedObject = anyObject()
        client.setRead(returnedObject: expectedObject)
        
        await expectLoad(sut, toCompleteWith: .success(expectedObject))
    }
    
    func test_load_hasNoSideEffectsWhenCalledTwice() async {
        let (sut, client) = makeSUT()
        
        let expectedObject = anyObject()
        client.setRead(returnedObject: expectedObject)
        
        await expectLoad(sut, toCompleteWith: .success(expectedObject))
        await expectLoad(sut, toCompleteWith: .success(expectedObject))
    }
    
    func test_save_doesntWriteOnDeletionError() async {
        let (sut, client) = makeSUT()
        let expectedError = anyNSError()
        client.setDeletion(error: expectedError)
        
        try? await sut.save(object: anyObject())
        
        XCTAssertEqual(client.messages, [.delete])
    }
    
    func test_save_returnsErrorOnDeletionError() async {
        let (sut, client) = makeSUT()
        let expectedError = anyNSError()
        client.setDeletion(error: expectedError)
        
        await expectSave(sut, toCompleteWith: expectedError)
    }
    
    func test_save_writesAfterDeletionSucceeded() async {
        let (sut, client) = makeSUT()
        client.setDeletion(error: nil)
        
        try? await sut.save(object: anyObject())
        
        XCTAssertEqual(client.messages, [.delete, .write])
    }
    
    func test_save_returnsErrorOnWriteError() async {
        let (sut, client) = makeSUT()
        let expectedError = anyNSError()

        client.setDeletion(error: nil)
        client.setWrite(error: expectedError)
        
        await expectSave(sut, toCompleteWith: expectedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalResourceLoader<String>, client: ResourceStoreSpy<String>) {
        let client = ResourceStoreSpy<String>()
        let sut = LocalResourceLoader<String>(client: client)
        return (sut, client)
    }
    
    private func expectLoad(_ sut: LocalResourceLoader<String>, toCompleteWith expectedResult: Result<String, Error>) async {
        do {
            let resultObject = try await sut.load()
            XCTAssertEqual(resultObject, try expectedResult.get())
        } catch {
            XCTAssertEqual(error as NSError, expectedResult.error as NSError?)
        }
    }
    
    private func expectSave(_ sut: LocalResourceLoader<String>, toCompleteWith expectedError: Error?) async {
        do {
            try await sut.save(object: anyObject())
        } catch {
            XCTAssertEqual(error as NSError, expectedError as NSError?)
        }
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }
    
    private func anyObject() -> String {
        return "any object"
    }
    
}

private extension Result {
    var error: Error? {
        switch self {
        case let .failure(error):
            return error
        default:
            return nil
        }
    }
}

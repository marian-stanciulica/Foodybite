//
//  LocalResourceLoaderTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 29.10.2022.
//

import XCTest

class LocalResourceLoader<Client: ResourceStore> {
    private let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func load() async throws -> Client.T {
        return try await client.read()
    }
    
    func save(object: Client.T) async throws {
        try await client.delete(Client.T.self)
        try await client.write(object)
    }
}

protocol ResourceStore {
    associatedtype T
    
    func read() async throws -> T
    func write(_ object: T) async throws
    func delete(_ type: T.Type) async throws
}

class ResourceStoreSpy<T>: ResourceStore {
    enum Message {
        case read
        case write
        case delete
    }
    
    struct CompletionNotSet: Error {}
    
    private(set) var messages = [Message]()
    
    private(set) var readResult: Result<T, Error>?
    
    private(set) var writeError: Error? = nil
    private(set) var writeParameter: T?

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
    
    func write(_ object: T) async throws {
        messages.append(.write)
        writeParameter = object
        
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
    
    func test_save_sendsParameterToWrite() async {
        let (sut, client) = makeSUT()
        client.setDeletion(error: nil)
        
        try? await sut.save(object: anyObject())
        
        XCTAssertEqual(client.writeParameter, anyObject())
    }
    
    func test_save_returnsErrorOnWriteError() async {
        let (sut, client) = makeSUT()
        let expectedError = anyNSError()

        client.setDeletion(error: nil)
        client.setWrite(error: expectedError)
        
        await expectSave(sut, toCompleteWith: expectedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalResourceLoader<ResourceStoreSpy<String>>, client: ResourceStoreSpy<String>) {
        let client = ResourceStoreSpy<String>()
        let sut = LocalResourceLoader<ResourceStoreSpy<String>>(client: client)
        return (sut, client)
    }
    
    private func expectLoad(_ sut: LocalResourceLoader<ResourceStoreSpy<String>>, toCompleteWith expectedResult: Result<String, Error>) async {
        do {
            let resultObject = try await sut.load()
            XCTAssertEqual(resultObject, try expectedResult.get())
        } catch {
            XCTAssertEqual(error as NSError, expectedResult.error as NSError?)
        }
    }
    
    private func expectSave(_ sut: LocalResourceLoader<ResourceStoreSpy<String>>, toCompleteWith expectedError: Error?) async {
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

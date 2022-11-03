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
    
    func save(object: T, completion: @escaping (Error?) -> Void) {
        client.delete(T.self) { [unowned self] error in
            if let error = error {
                completion(error)
            } else {
                self.client.write { error in
                    if let error = error {
                        completion(error)
                    }
                }
            }
        }
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
    
    private(set) var readCompletion: Result<T, Error>?
    private(set) var writeCompletions = [(Error?) -> Void]()
    private(set) var deletionCompletions = [(Error?) -> Void]()
    
    func read() async throws -> T {
        messages.append(.read)
        
        if let readCompletion = readCompletion {
            return try readCompletion.get()
        } else {
            throw CompletionNotSet()
        }
    }
    
    func setRead(error: Error) {
        readCompletion = .failure(error)
    }
    
    func setRead(returnedObject object: T) {
        readCompletion = .success(object)
    }
    
    func write(completion: @escaping (Error?) -> Void) {
        messages.append(.write)
        writeCompletions.append(completion)
    }
    
    func completeWrite(withError error: Error?, at index: Int = 0) {
        writeCompletions[index](error)
    }
    
    func delete(_ type: T.Type, completion: @escaping (Error?) -> Void) {
        messages.append(.delete)
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(withError error: Error?, at index: Int = 0) {
        deletionCompletions[index](error)
    }
}

final class LocalResourceLoaderTests: XCTestCase {

    func test_load_callClientRead() async {
        let (sut, client) = makeSUT()
        
        _ = try? await sut.load()
        
        XCTAssertEqual(client.messages.count, 1)
    }
    
    func test_load_returnsErrorOnClientError() async {
        let (sut, client) = makeSUT()
        
        let expectedError = NSError(domain: "any error", code: 1)
        client.setRead(error: expectedError)
        
        do {
            _ = try await sut.load()
            XCTFail("Load expected to fail")
        } catch {
            XCTAssertEqual(expectedError, error as NSError)
        }
    }
    
    func test_load_returnsObjectSuccessfullyOnClientSuccess() async {
        let (sut, client) = makeSUT()
        let expectedObject = "expected object"
        client.setRead(returnedObject: expectedObject)
        
        do {
            let resultObject = try await sut.load()
            XCTAssertEqual(resultObject, expectedObject)
        } catch {
            XCTFail("Load expected to return object")
        }
    }
    
    func test_load_returnsSameObjectWhenCalledTwice() async {
        let (sut, client) = makeSUT()
        let expectedObject = "expected object"
        client.setRead(returnedObject: expectedObject)
        
        do {
            let resultObject = try await sut.load()
            XCTAssertEqual(resultObject, expectedObject)
        } catch {
            XCTFail("Load expected to return object")
        }
        
        do {
            let resultObject = try await sut.load()
            XCTAssertEqual(resultObject, expectedObject)
        } catch {
            XCTFail("Load expected to return object")
        }
    }
    
    func test_save_requestDeletion() {
        let (sut, client) = makeSUT()
        
        sut.save(object: "any string") { _ in }
        
        XCTAssertEqual(client.messages, [.delete])
    }
    
    func test_save_doesntWriteOnDeletionError() {
        let (sut, client) = makeSUT()
        let expectedError = NSError(domain: "any error", code: 1)
        
        sut.save(object: "any string") { _ in }
        
        client.completeDeletion(withError: expectedError)
        
        XCTAssertEqual(client.messages, [.delete])
    }
    
    func test_save_writesAfterDeletionSucceeded() {
        let (sut, client) = makeSUT()
        
        sut.save(object: "any string") { _ in }
        
        client.completeDeletion(withError: nil)
        
        XCTAssertEqual(client.messages, [.delete, .write])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalResourceLoader<String>, client: ResourceStoreSpy<String>) {
        let client = ResourceStoreSpy<String>()
        let sut = LocalResourceLoader<String>(client: client)
        return (sut, client)
    }
    
//    private func expectLoad(_ sut: LocalResourceLoader<String>, toCompleteWith expectedResult: Result<String, Error>, action: () -> Void) {
//        sut.load { receivedResult in
//            switch (receivedResult, expectedResult) {
//            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
//                XCTAssertEqual(receivedError, expectedError)
//            case let (.success(receivedObject), .success(expectedObject)):
//                XCTAssertEqual(receivedObject, expectedObject)
//            default:
//                XCTFail("Expected to receive result \(expectedResult), got \(receivedResult) instead")
//            }
//        }
//
//        action()
//    }
    
}

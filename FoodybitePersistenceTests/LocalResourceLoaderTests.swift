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
    
    func load(completion: @escaping (Result<T, Error>) -> Void) {
        client.read { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(object):
                completion(.success(object))
            }
        }
    }
    
    func save(object: T, completion: @escaping (Error?) -> Void) {
        client.delete(T.self) { error in
            if let error = error {
                completion(error)
            }
        }
        
        client.write { error in
            if let error = error {
                completion(error)
            }
        }
    }
    
}

class ResourceStoreSpy<T> {
    private(set) var readCompletions = [(Result<T, Error>) -> Void]()
    private(set) var writeCompletions = [(Error?) -> Void]()
    private(set) var deletionCompletions = [(Error?) -> Void]()
    
    func read(completion: @escaping (Result<T, Error>) -> Void) {
        readCompletions.append(completion)
    }
    
    func completeLoad(withError error: Error, at index: Int = 0) {
        readCompletions[index](.failure(error))
    }
    
    func completeLoadSuccessfully(with object: T, at index: Int = 0) {
        readCompletions[index](.success(object))
    }
    
    func write(completion: @escaping (Error?) -> Void) {
        writeCompletions.append(completion)
    }
    
    func completeSave(withError error: Error?, at index: Int = 0) {
        writeCompletions[index](error)
    }
    
    func delete(_ type: T.Type, completion: @escaping (Error?) -> Void) {
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(withError error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
}

final class LocalResourceLoaderTests: XCTestCase {

    func test_load_callClientRead() {
        let (sut, client) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(client.readCompletions.count, 1)
    }
    
    func test_load_returnsErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        let expectedError = NSError(domain: "any error", code: 1)
        expectLoad(sut, toCompleteWith: .failure(expectedError)) {
            client.completeLoad(withError: expectedError)
        }
    }
    
    func test_load_returnsObjectSuccessfullyOnClientSuccess() {
        let (sut, client) = makeSUT()
        let expectedObject = "expected object"
        
        expectLoad(sut, toCompleteWith: .success(expectedObject)) {
            client.completeLoadSuccessfully(with: expectedObject)
        }
    }
    
    func test_load_returnsSameObjectWhenCalledTwice() {
        let (sut, client) = makeSUT()
        let expectedObject = "expected object"
        
        expectLoad(sut, toCompleteWith: .success(expectedObject)) {
            client.completeLoadSuccessfully(with: expectedObject)
        }
        
        expectLoad(sut, toCompleteWith: .success(expectedObject)) {
            client.completeLoadSuccessfully(with: expectedObject)
        }
    }
    
    func test_save_returnsErrorOnSavingError() {
        let (sut, client) = makeSUT()
        let expectedError = NSError(domain: "any error", code: 1)
        
        var receivedError: NSError?
        sut.save(object: "any string") { receivedError = $0 as NSError? }
        
        client.completeSave(withError: expectedError)
        
        XCTAssertEqual(receivedError, expectedError)
    }
    
    func test_save_returnsErrorOnDeletionError() {
        let (sut, client) = makeSUT()
        let expectedError = NSError(domain: "any error", code: 1)
        
        var receivedError: NSError?
        sut.save(object: "any string") { receivedError = $0 as NSError? }
        
        client.completeDeletion(withError: expectedError)
        
        XCTAssertEqual(receivedError, expectedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalResourceLoader<String>, client: ResourceStoreSpy<String>) {
        let client = ResourceStoreSpy<String>()
        let sut = LocalResourceLoader<String>(client: client)
        return (sut, client)
    }
    
    private func expectLoad(_ sut: LocalResourceLoader<String>, toCompleteWith expectedResult: Result<String, Error>, action: () -> Void) {
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError)
            case let (.success(receivedObject), .success(expectedObject)):
                XCTAssertEqual(receivedObject, expectedObject)
            default:
                XCTFail("Expected to receive result \(expectedResult), got \(receivedResult) instead")
            }
        }
        
        action()
    }
    
}

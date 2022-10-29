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
}

class ResourceStoreSpy<T> {
    private(set) var readCompletions = [(Result<T, Error>) -> Void]()
    
    func read(completion: @escaping (Result<T, Error>) -> Void) {
        readCompletions.append(completion)
    }
    
    func complete(withError error: Error, at index: Int = 0) {
        readCompletions[index](.failure(error))
    }
    
    func completeSuccessfully(with object: T, at index: Int = 0) {
        readCompletions[index](.success(object))
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
        expect(sut, toCompleteWith: .failure(expectedError)) {
            client.complete(withError: expectedError)
        }
    }
    
    func test_load_returnsObjectSuccessfullyOnClientSuccess() {
        let (sut, client) = makeSUT()
        let expectedObject = "expected object"
        
        expect(sut, toCompleteWith: .success(expectedObject)) {
            client.completeSuccessfully(with: expectedObject)
        }
    }
    
    func test_load_returnsSameObjectWhenCalledTwice() {
        let (sut, client) = makeSUT()
        let expectedObject = "expected object"
        
        expect(sut, toCompleteWith: .success(expectedObject)) {
            client.completeSuccessfully(with: expectedObject)
        }
        
        expect(sut, toCompleteWith: .success(expectedObject)) {
            client.completeSuccessfully(with: expectedObject)
        }
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalResourceLoader<String>, client: ResourceStoreSpy<String>) {
        let client = ResourceStoreSpy<String>()
        let sut = LocalResourceLoader<String>(client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: LocalResourceLoader<String>, toCompleteWith expectedResult: Result<String, Error>, action: () -> Void) {
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

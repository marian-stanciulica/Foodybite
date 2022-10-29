//
//  LocalResourceLoaderTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 29.10.2022.
//

import XCTest

class LocalResourceLoader {
    private let client: ResourceStoreSpy
    
    enum LoadResult {
        case empty
        case failure(Error)
        case success(String)
    }
    
    init(client: ResourceStoreSpy) {
        self.client = client
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
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

class ResourceStoreSpy {
    private(set) var readCalled = 0
    private(set) var readCompletions = [(Result<String, Error>) -> Void]()
    
    func read(completion: @escaping (Result<String, Error>) -> Void) {
        readCalled += 1
        readCompletions.append(completion)
    }
    
    func complete(with error: Error, at index: Int = 0) {
        readCompletions[index](.failure(error))
    }
    
    func completeSuccessfully(with object: String, at index: Int = 0) {
        readCompletions[index](.success(object))
    }
    
}

final class LocalResourceLoaderTests: XCTestCase {

    func test_load_callClientRead() {
        let client = ResourceStoreSpy()
        let sut = LocalResourceLoader(client: client)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.readCalled, 1)
    }
    
    func test_load_returnsErrorOnClientError() {
        let client = ResourceStoreSpy()
        let sut = LocalResourceLoader(client: client)
        let expectedError = NSError(domain: "any error", code: 1)
        
        var receivedError: NSError?
        sut.load { result in
            switch result {
            case let .failure(error):
                receivedError = error as NSError
            default:
                XCTFail("Expected to receive error, got \(result) instead")
            }
        }
        
        client.complete(with: expectedError)
        
        XCTAssertEqual(receivedError, expectedError)
    }
    
    func test_load_returnsObjectSuccessfullyOnClientSuccess() {
        let client = ResourceStoreSpy()
        let sut = LocalResourceLoader(client: client)
        let expectedObject = "expected object"
        
        var receivedObject: String?
        sut.load { result in
            switch result {
            case let .success(object):
                receivedObject = object
            default:
                XCTFail("Expected to receive error, got \(result) instead")
            }
        }
        
        client.completeSuccessfully(with: expectedObject)
        
        XCTAssertEqual(receivedObject, expectedObject)
    }
    
}

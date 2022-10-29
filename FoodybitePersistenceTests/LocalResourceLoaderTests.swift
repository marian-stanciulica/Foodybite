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
        client.read { error in
            if let error = error {
                completion(.failure(error))
            }
        }
    }
}

class ResourceStoreSpy {
    private(set) var readCalled = 0
    private(set) var readCompletions = [(Error?) -> Void]()
    
    func read(completion: @escaping (Error?) -> Void) {
        readCalled += 1
        readCompletions.append(completion)
    }
    
    func complete(with error: Error, at index: Int = 0) {
        readCompletions[index](error)
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
    
}

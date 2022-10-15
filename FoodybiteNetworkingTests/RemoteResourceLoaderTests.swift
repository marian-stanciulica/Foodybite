//
//  RemoteResourceLoaderTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

class CodableDataParser {
    private let jsonDecoder = JSONDecoder()
    
    func decode<T: Decodable>(data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }
    
}

class RemoteResourceLoader {
    private let client: HTTPClientSpy
    private let codableDataParser = CodableDataParser()
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(client: HTTPClientSpy) {
        self.client = client
    }
    
    func get<T: Decodable>(for urlRequest: URLRequest) throws -> T {
        let result: (data: Data, response: HTTPURLResponse)
        
        do {
            result = try client.get(for: urlRequest)
        } catch {
            throw Error.connectivity
        }
        
        guard (200..<300).contains(result.response.statusCode) else {
            throw Error.invalidData
        }
        
        do {
            return try codableDataParser.decode(data: result.data)
        } catch {
            throw Error.invalidData
        }
    }
}

class HTTPClientSpy {
    var urlRequests = [URLRequest]()
    var result: Result<(Data, HTTPURLResponse), NSError>?
    
    func get(for urlRequest: URLRequest) throws -> (Data, HTTPURLResponse) {
        urlRequests.append(urlRequest)
        
        if let result = result {
            switch result {
            case let .failure(error):
                throw error
            case let .success(result):
                return result
            }
        }
        
        return (anyLoginMocksData(), anyHttpUrlResponse())
    }
    
    private func anyHttpUrlResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil)!
    }
    
    private func anyLoginMocksData() -> Data {
        let loginMocks = [
            CodableMock(name: "name 1", password: "password 1"),
            CodableMock(name: "name 2", password: "password 2")
        ]
        return try! JSONEncoder().encode(loginMocks)
    }
}

struct CodableMock: Codable {
    let name: String
    let password: String
}

final class RemoteResourceLoaderTests: XCTestCase {

    func test_init_noRequestTriggered() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.urlRequests, [])
    }
    
    func test_get_requestDataForEndpoint() {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        do {
            let _: [CodableMock] = try sut.get(for: urlRequest)
        } catch {
            XCTFail("Decoding failed")
        }
            
        XCTAssertEqual(client.urlRequests, [urlRequest])
    }
    
    func test_get_requestsDataForEndpointTwice() {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        do {
            let _: [CodableMock] = try sut.get(for: urlRequest)
            let _: [CodableMock] = try sut.get(for: urlRequest)
        } catch {
            XCTFail("Decoding failed")
        }
        
        XCTAssertEqual(client.urlRequests, [urlRequest, urlRequest])
    }
    
    func test_get_throwErrorOnClientError() {
        expect(forClientResult: .failure(NSError(domain: "any error", code: 1)),
                   expected: .connectivity)
    }
    
    func test_get_throwErrorOnNon2xxStatusCodeResponse() {
        let samples = [150, 199, 300, 301, 400, 500]
        
        samples.forEach { code in
            let anyData = "any data".data(using: .utf8)!
            let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            
            expect(forClientResult: .success((data: anyData, response: response)),
                       expected: .invalidData)
        }
    }
    
    func test_get_throwErrorOnInvalidJSON() {
        let anyData = "any data".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        expect(forClientResult: .success((data: anyData, response: response)),
                   expected: .invalidData)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemoteResourceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteResourceLoader(client: client)
        
        return (sut, client)
    }
    
    private func expect(forClientResult result: Result<(Data, HTTPURLResponse), NSError>, expected: RemoteResourceLoader.Error, file: StaticString = #filePath, line: UInt = #line) {
        let (sut, client) = makeSUT()
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        client.result = result
        
        var receivedError: NSError?
        do {
            let _: [CodableMock] = try sut.get(for: urlRequest)
        } catch {
            receivedError = error as NSError
        }
        
        XCTAssertEqual(receivedError, expected as NSError, file: file, line: line)
    }
    
}

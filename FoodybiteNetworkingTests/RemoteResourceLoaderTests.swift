//
//  RemoteResourceLoaderTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

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
               expected: .failure(.connectivity))
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
                   expected: .failure(.invalidData))
        }
    }
    
    func test_get_throwErrorOn2xxStatusCodeWithInvalidJSON() {
        let anyData = "any data".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        expect(forClientResult: .success((data: anyData, response: response)),
               expected: .failure(.invalidData))
    }
    
    func test_get_returnsEmptyArrayOn2xxStatusWithEmptyJSONList() {
        let anyData = "{\"mocks\":[]}".data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        expect(forClientResult: .success((data: anyData, response: response)),
               expected: .success([]))
    }
    
    func test_get_returnsMocksArrayOn2xxStatusWithValidMocksJSONList() {
        let anyMocks = anyMocks()
        let response = HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        expect(forClientResult: .success((data: anyMocks.data, response: response)),
               expected: .success(anyMocks.container.mocks))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemoteResourceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteResourceLoader(client: client)
        
        return (sut, client)
    }
    
    private func expect(forClientResult result: Result<(Data, HTTPURLResponse), NSError>,
                        expected:  Result<[CodableMock], RemoteResourceLoader.Error>,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        let (sut, client) = makeSUT()
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        client.result = result
        
        var receivedError: NSError?
        var receivedMocks: CodableArrayMock?
        
        do {
            receivedMocks = try sut.get(for: urlRequest)
        } catch {
            receivedError = error as NSError
        }
        
        switch expected {
        case let .success(expectedMocks):
            XCTAssertEqual(receivedMocks?.mocks, expectedMocks, file: file, line: line)
        case let .failure(error):
            XCTAssertEqual(receivedError, error as NSError, file: file, line: line)
        }
    }
    
    private func anyMocks() -> (container: CodableArrayMock, data: Data) {
        let mocks = [
            CodableMock(name: "name 1", password: "password 1"),
            CodableMock(name: "name 2", password: "password 2")
        ]
        let mocksContainer = CodableArrayMock(mocks: mocks)
        let data = try! JSONEncoder().encode(mocksContainer)
        return (mocksContainer, data)
    }
    
}

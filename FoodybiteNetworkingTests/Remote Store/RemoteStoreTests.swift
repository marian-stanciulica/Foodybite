//
//  RemoteStoreTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
import FoodybiteNetworking

final class RemoteStoreTests: XCTestCase {

    func test_init_noRequestTriggered() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.urlRequests, [])
    }
    
    func test_get_requestDataForEndpoint() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        do {
            let _: [CodableMock] = try await sut.get(for: urlRequest)
        } catch {
            XCTFail("Decoding failed")
        }
            
        XCTAssertEqual(client.urlRequests, [urlRequest])
    }
    
    func test_get_requestsDataForEndpointTwice() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        do {
            let _: [CodableMock] = try await sut.get(for: urlRequest)
            let _: [CodableMock] = try await sut.get(for: urlRequest)
        } catch {
            XCTFail("Decoding failed")
        }
        
        XCTAssertEqual(client.urlRequests, [urlRequest, urlRequest])
    }
    
    func test_get_throwErrorOnClientError() async {
        await expectGet(forClientResult: .failure(anyError()),
               expected: .failure(.connectivity))
    }
    
    func test_get_throwErrorOnNon2xxStatusCodeResponse() async {
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 150))),
                     expected: .failure(.invalidRequest))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 199))),
                     expected: .failure(.invalidRequest))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 300))),
                     expected: .failure(.invalidRequest))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 301))),
                     expected: .failure(.invalidRequest))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 400))),
                     expected: .failure(.invalidRequest))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 500))),
                     expected: .failure(.invalidRequest))
    }
    
    func test_get_throwErrorOn2xxStatusCodeWithInvalidJSON() async {
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse())),
               expected: .failure(.invalidData))
    }
    
    func test_get_returnsEmptyArrayOn2xxStatusWithEmptyJSONList() async {
        let emptyArrayData = "{\"mocks\":[]}".data(using: .utf8)!
        
        await expectGet(forClientResult: .success((data: emptyArrayData, response: anyHttpUrlResponse())),
               expected: .success([]))
    }
    
    func test_get_returnsMocksArrayOn2xxStatusWithValidMocksJSONList() async {
        let anyMocks = anyMocks()
        
        await expectGet(forClientResult: .success((data: anyMocks.data, response: anyHttpUrlResponse())),
               expected: .success(anyMocks.container.mocks))
    }
    
    func test_post_requestDataForEndpoint() async throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        do {
            try await sut.post(to: urlRequest)
        } catch {
            XCTFail("Decoding failed")
        }
            
        XCTAssertEqual(client.urlRequests, [urlRequest])
    }
    
    func test_post_requestsDataForEndpointTwice() async throws {
        let urlRequest = try EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        do {
            try await sut.post(to: urlRequest)
            try await sut.post(to: urlRequest)
        } catch {
            XCTFail("Invalid data")
        }
        
        XCTAssertEqual(client.urlRequests, [urlRequest, urlRequest])
    }
    
    func test_post_throwErrorOnClientError() async {
        await expectPost(forClientResult: .failure(anyError()),
                         expectedError: .connectivity)
    }
    
    func test_post_throwErrorOnNon2xxStatusCodeResponse() async {
        await expectPost(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 150))),
                         expectedError: .invalidRequest)
        await expectPost(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 199))),
                         expectedError: .invalidRequest)
        await expectPost(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 300))),
                         expectedError: .invalidRequest)
        await expectPost(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 301))),
                         expectedError: .invalidRequest)
        await expectPost(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 400))),
                         expectedError: .invalidRequest)
        await expectPost(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 500))),
                         expectedError: .invalidRequest)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemoteStore, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = FoodybiteNetworking.RemoteStore(client: client)
        
        return (sut, client)
    }
    
    private func expectGet(forClientResult result: Result<(Data, HTTPURLResponse), NSError>,
                           expected: Result<[CodableMock], RemoteStore.Error>,
                           file: StaticString = #filePath,
                           line: UInt = #line) async {
        let (sut, client) = makeSUT()
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        client.result = result
        
        var receivedError: NSError?
        var receivedMocks: CodableArrayMock?
        
        do {
            receivedMocks = try await sut.get(for: urlRequest)
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
    
    private func expectPost(forClientResult result: Result<(Data, HTTPURLResponse), NSError>,
                            expectedError:  RemoteStore.Error?,
                            file: StaticString = #filePath,
                            line: UInt = #line) async {
        let (sut, client) = makeSUT()
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        client.result = result
        
        var receivedError: NSError?
        
        do {
            try await sut.post(to: urlRequest)
        } catch {
            receivedError = error as NSError
        }
        
        XCTAssertEqual(receivedError, expectedError as? NSError, file: file, line: line)
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

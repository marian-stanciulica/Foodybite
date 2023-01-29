//
//  RemoteResourceLoaderTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces

final class RemoteResourceLoaderTests: XCTestCase {

    func test_init_noRequestTriggered() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.urlRequests, [])
    }
    
    func test_get_requestDecodableForEndpoint() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        do {
            let _: [CodableMock] = try await sut.get(for: urlRequest)
        } catch {
            XCTFail("Decoding failed")
        }
            
        XCTAssertEqual(client.urlRequests, [urlRequest])
    }
    
    func test_get_requestsDecodableForEndpointTwice() async {
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
                     expected: .failure(.invalidData))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 199))),
                     expected: .failure(.invalidData))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 300))),
                     expected: .failure(.invalidData))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 301))),
                     expected: .failure(.invalidData))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 400))),
                     expected: .failure(.invalidData))
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 500))),
                     expected: .failure(.invalidData))
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
    
    func test_getData_requestsDataForEndpoint() async {
        let urlRequest = try! EndpointStub.stub.createURLRequest()
        let (sut, client) = makeSUT()
        
        _ = try? await sut.getData(for: urlRequest)
            
        XCTAssertEqual(client.urlRequests, [urlRequest])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemoteResourceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteResourceLoader(client: client)
        
        return (sut, client)
    }
    
    private func expectGet(forClientResult result: Result<(Data, HTTPURLResponse), NSError>,
                           expected: Result<[CodableMock], RemoteResourceLoader.Error>,
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

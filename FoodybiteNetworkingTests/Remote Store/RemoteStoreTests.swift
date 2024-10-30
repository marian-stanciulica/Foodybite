//
//  RemoteStoreTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Testing
import Foundation.NSError
import Foundation.NSData
import FoodybiteNetworking

struct RemoteStoreTests {

    @Test func init_noRequestTriggered() {
        let (_, client) = makeSUT()

        #expect(client.urlRequests.isEmpty)
    }

    @Test func get_requestDataForEndpoint() async {
        let urlRequest = anyUrlRequest()
        let (sut, client) = makeSUT()

        let _: [CodableMock]? = try? await sut.get(for: urlRequest)

        #expect(client.urlRequests == [urlRequest])
    }

    @Test func get_requestsDataForEndpointTwice() async {
        let urlRequest = anyUrlRequest()
        let (sut, client) = makeSUT()

        let _: [CodableMock]? = try? await sut.get(for: urlRequest)
        let _: [CodableMock]? = try? await sut.get(for: urlRequest)

        #expect(client.urlRequests == [urlRequest, urlRequest])
    }

    @Test func get_throwErrorOnClientError() async {
        await expectGet(forClientResult: .failure(anyError()),
               expected: .failure(.connectivity))
    }

    @Test func get_throwErrorOnNon2xxStatusCodeResponse() async {
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

    @Test func get_throwErrorOn2xxStatusCodeWithInvalidJSON() async {
        await expectGet(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse())),
               expected: .failure(.invalidData))
    }

    @Test func get_returnsEmptyArrayOn2xxStatusWithEmptyJSONList() async {
        let emptyArrayData = "{\"mocks\":[]}".data(using: .utf8)!

        await expectGet(forClientResult: .success((data: emptyArrayData, response: anyHttpUrlResponse())),
               expected: .success([]))
    }

    @Test func get_returnsMocksArrayOn2xxStatusWithValidMocksJSONList() async throws {
        let anyMocks = try anyMocks()

        await expectGet(forClientResult: .success((data: anyMocks.data, response: anyHttpUrlResponse())),
               expected: .success(anyMocks.container.mocks))
    }

    @Test func post_requestDataForEndpoint() async {
        let urlRequest = anyUrlRequest()
        let (sut, client) = makeSUT()

        try? await sut.post(to: urlRequest)

        #expect(client.urlRequests == [urlRequest])
    }

    @Test func post_requestsDataForEndpointTwice() async {
        let urlRequest = anyUrlRequest()
        let (sut, client) = makeSUT()

        try? await sut.post(to: urlRequest)
        try? await sut.post(to: urlRequest)

        #expect(client.urlRequests == [urlRequest, urlRequest])
    }

    @Test func post_throwErrorOnClientError() async {
        await expectPost(forClientResult: .failure(anyError()),
                         expectedError: .connectivity)
    }

    @Test func post_throwErrorOnNon2xxStatusCodeResponse() async {
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
        let sut = RemoteStore(client: client)

        return (sut, client)
    }

    private func expectGet(forClientResult result: Result<(Data, HTTPURLResponse), NSError>,
                           expected: Result<[CodableMock], RemoteStore.Error>,
                           sourceLocation: SourceLocation = #_sourceLocation) async {
        let (sut, client) = makeSUT()
        let urlRequest = anyUrlRequest()
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
            #expect(receivedMocks?.mocks == expectedMocks, sourceLocation: sourceLocation)
        case let .failure(error):
            #expect(receivedError == error as NSError, sourceLocation: sourceLocation)
        }
    }

    private func expectPost(forClientResult result: Result<(Data, HTTPURLResponse), NSError>,
                            expectedError: RemoteStore.Error?,
                            sourceLocation: SourceLocation = #_sourceLocation) async {
        let (sut, client) = makeSUT()
        let urlRequest = anyUrlRequest()
        client.result = result

        var receivedError: NSError?

        do {
            try await sut.post(to: urlRequest)
        } catch {
            receivedError = error as NSError
        }

        #expect(receivedError == expectedError as? NSError, sourceLocation: sourceLocation)
    }

    private func anyMocks() throws -> (container: CodableArrayMock, data: Data) {
        let mocks = [
            CodableMock(name: "name 1", password: "password 1"),
            CodableMock(name: "name 2", password: "password 2")
        ]
        let mocksContainer = CodableArrayMock(mocks: mocks)
        let data = try JSONEncoder().encode(mocksContainer)
        return (mocksContainer, data)
    }

}

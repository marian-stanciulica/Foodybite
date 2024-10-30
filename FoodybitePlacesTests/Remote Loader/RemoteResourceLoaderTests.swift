//
//  RemoteResourceLoaderTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Testing
import Foundation.NSError
import Foundation.NSData
import FoodybitePlaces

struct RemoteResourceLoaderTests {

    @Test func init_noRequestTriggered() {
        let (_, client) = makeSUT()

        #expect(client.urlRequests.isEmpty)
    }

    @Test func get_requestDecodableForEndpoint() async {
        let urlRequest = anyUrlRequest()
        let (sut, client) = makeSUT()

        do {
            let _: [CodableMock] = try await sut.get(for: urlRequest)
        } catch {
            Issue.record("Decoding failed")
        }

        #expect(client.urlRequests == [urlRequest])
    }

    @Test func get_requestsDecodableForEndpointTwice() async {
        let urlRequest = anyUrlRequest()
        let (sut, client) = makeSUT()

        do {
            let _: [CodableMock] = try await sut.get(for: urlRequest)
            let _: [CodableMock] = try await sut.get(for: urlRequest)
        } catch {
            Issue.record("Decoding failed")
        }

        #expect(client.urlRequests == [urlRequest, urlRequest])
    }

    @Test func get_throwErrorOnClientError() async {
        await expectGet(forClientResult: .failure(anyError()),
               expected: .failure(.connectivity))
    }

    @Test func get_throwErrorOnNon2xxStatusCodeResponse() async {
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

    @Test func getData_requestsDataForEndpoint() async {
        let urlRequest = anyUrlRequest()
        let (sut, client) = makeSUT()

        _ = try? await sut.getData(for: urlRequest)

        #expect(client.urlRequests == [urlRequest])
    }

    @Test func getData_requestsDataForEndpointTwice() async throws {
        let urlRequest = anyUrlRequest()
        let (sut, client) = makeSUT()

        _ = try await sut.getData(for: urlRequest)
        _ = try await sut.getData(for: urlRequest)

        #expect(client.urlRequests == [urlRequest, urlRequest])
    }

    @Test func getData_throwsErrorOnClientError() async {
        await expectGetData(forClientResult: .failure(anyError()),
                            expected: .failure(.connectivity))
    }

    @Test func getData_throwsErrorOnNon2xxStatusCodeResponse() async {
        await expectGetData(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 150))),
                            expected: .failure(.invalidData))
        await expectGetData(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 199))),
                            expected: .failure(.invalidData))
        await expectGetData(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 300))),
                            expected: .failure(.invalidData))
        await expectGetData(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 301))),
                            expected: .failure(.invalidData))
        await expectGetData(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 400))),
                            expected: .failure(.invalidData))
        await expectGetData(forClientResult: .success((data: anyData(), response: anyHttpUrlResponse(code: 500))),
                            expected: .failure(.invalidData))
    }

    @Test func getData_returnsDataOn2xxStatusCodeResponseFromClient() async {
        let anyData = anyData()

        await expectGetData(forClientResult: .success((data: anyData, response: anyHttpUrlResponse())),
                            expected: .success(anyData))
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: RemoteLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader(client: client)

        return (sut, client)
    }

    private func expectGet(forClientResult result: Result<(Data, HTTPURLResponse), NSError>,
                           expected: Result<[CodableMock], RemoteLoader.Error>,
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

    private func expectGetData(forClientResult result: Result<(Data, HTTPURLResponse), NSError>,
                               expected: Result<Data, RemoteLoader.Error>,
                               sourceLocation: SourceLocation = #_sourceLocation) async {
        let (sut, client) = makeSUT()
        let urlRequest = anyUrlRequest()
        client.result = result

        var receivedError: NSError?
        var receivedData: Data?

        do {
            receivedData = try await sut.getData(for: urlRequest)
        } catch {
            receivedError = error as NSError
        }

        switch expected {
        case let .success(expectedData):
            #expect(receivedData == expectedData, sourceLocation: sourceLocation)
        case let .failure(error):
            #expect(receivedError == error as NSError, sourceLocation: sourceLocation)
        }
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

    private func anyUrlRequest() -> URLRequest {
        URLRequest(url: URL(string: "http://any-url.com")!)
    }
}

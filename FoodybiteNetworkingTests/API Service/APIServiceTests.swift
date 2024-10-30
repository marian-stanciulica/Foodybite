//
//  APIServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Testing
import CryptoKit
import Domain
import Foundation.NSURLRequest
@testable import FoodybiteNetworking

struct APIServiceTests {

    func makeSUT(response: Decodable? = nil) -> (
        sut: APIService,
        loader: ResourceLoaderSpy,
        sender: ResourceSenderSpy,
        tokenStoreStub: TokenStoreStub
    ) {
        let tokenStoreStub = TokenStoreStub()
        let loader = ResourceLoaderSpy(response: response ?? "any decodable")
        let sender = ResourceSenderSpy()
        let sut = APIService(loader: loader, sender: sender, tokenStore: tokenStoreStub)
        return (sut, loader, sender, tokenStoreStub)
    }

    func assertURLComponents(
        urlRequest: URLRequest,
        path: String,
        method: FoodybiteNetworking.RequestMethod,
        body: Encodable? = nil,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)

        #expect(urlComponents?.scheme ==  "http", "Scheme is not http", sourceLocation: sourceLocation)
        #expect(urlComponents?.port == 8080, "Port is not 8080", sourceLocation: sourceLocation)
        #expect(urlComponents?.host == "localhost", "Host is not localhost", sourceLocation: sourceLocation)
        #expect(urlComponents?.path == path, "Path is not \(path)", sourceLocation: sourceLocation)
        #expect(urlComponents?.queryItems == nil, "QueryItems are not nil", sourceLocation: sourceLocation)
        #expect(urlRequest.httpMethod == method.rawValue, "Wrong \(method.rawValue)", sourceLocation: sourceLocation)

        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .sortedKeys

            if let bodyData = try? encoder.encode(body) {
                #expect(urlRequest.httpBody == bodyData, "HTTP Body is not correct", sourceLocation: sourceLocation)
            } else {
                Issue.record("Couldn't encode the body", sourceLocation: sourceLocation)
            }
        } else if let httpBody = urlRequest.httpBody {
            Issue.record("Body expected to be nil, got \(httpBody) instead", sourceLocation: sourceLocation)
        }
    }

    func hash(password: String) -> String {
        let hashed = SHA512.hash(data: password.data(using: .utf8)!)
        return hashed.compactMap { String(format: "%02x", $0) } .joined()
    }

    func anyName() -> String {
        "any name"
    }

    func anyEmail() -> String {
        "test@test.com"
    }

    func anyPassword() -> String {
        "123@password$321"
    }
}

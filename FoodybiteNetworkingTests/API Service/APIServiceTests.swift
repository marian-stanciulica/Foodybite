//
//  APIServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import XCTest
import CryptoKit
import Domain
@testable import FoodybiteNetworking

final class APIServiceTests: XCTestCase {

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
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)

        XCTAssertEqual(urlComponents?.scheme, "http", "Scheme is not http", file: file, line: line)
        XCTAssertEqual(urlComponents?.port, 8080, "Port is not 8080", file: file, line: line)
        XCTAssertEqual(urlComponents?.host, "localhost", "Host is not localhost", file: file, line: line)
        XCTAssertEqual(urlComponents?.path, path, "Path is not \(path)", file: file, line: line)
        XCTAssertNil(urlComponents?.queryItems, "QueryItems are not nil", file: file, line: line)
        XCTAssertEqual(urlRequest.httpMethod, method.rawValue, "Wrong \(method.rawValue)", file: file, line: line)

        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .sortedKeys

            if let bodyData = try? encoder.encode(body) {
                XCTAssertEqual(urlRequest.httpBody, bodyData, "HTTP Body is not correct", file: file, line: line)
            } else {
                XCTFail("Couldn't encode the body", file: file, line: line)
            }
        } else if let httpBody = urlRequest.httpBody {
            XCTFail("Body expected to be nil, got \(httpBody) instead", file: file, line: line)
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

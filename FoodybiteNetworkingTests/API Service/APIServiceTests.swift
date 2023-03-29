//
//  APIServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import XCTest
import Domain
@testable import FoodybiteNetworking
import SharedAPI

final class APIServiceTests: XCTestCase {
    
    func makeSUT(response: Decodable? = nil) -> (sut: APIService, loader: ResourceLoaderSpy, sender: ResourceSenderSpy, tokenStoreStub: TokenStoreStub) {
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

        XCTAssertEqual(urlComponents?.scheme, "http", file: file, line: line)
        XCTAssertEqual(urlComponents?.port, 8080, file: file, line: line)
        XCTAssertEqual(urlComponents?.host, "localhost", file: file, line: line)
        XCTAssertEqual(urlComponents?.path, path, file: file, line: line)
        XCTAssertNil(urlComponents?.queryItems, file: file, line: line)
        XCTAssertEqual(urlRequest.httpMethod, method.rawValue, file: file, line: line)
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let bodyData = try! encoder.encode(body)
            XCTAssertEqual(urlRequest.httpBody, bodyData, file: file, line: line)
        } else if let httpBody = urlRequest.httpBody {
            XCTFail("Body expected to be nil, got \(httpBody) instead")
        }
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

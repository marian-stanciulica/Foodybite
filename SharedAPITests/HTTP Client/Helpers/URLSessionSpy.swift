//
//  URLSessionSpy.swift
//  SharedAPITests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation
@testable import SharedAPI

class URLSessionSpy: URLSessionProtocol {
    private(set) var requests = [URLRequest]()
    private let result: Result<(Data, URLResponse), Error>
    
    init(result: Result<(Data, URLResponse), Error> = .success((anyData(), anyValidResponse()))) {
        self.result = result
    }
    
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> (Data, URLResponse) {
        requests.append(request)
        return try result.get()
    }
    
    private static func anyData() -> Data {
        "any data".data(using: .utf8)!
    }
    
    private static func anyValidResponse() -> URLResponse {
        HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil)!
    }
}

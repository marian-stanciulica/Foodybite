//
//  Helpers.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

func anyUrlResponse() -> URLResponse {
    URLResponse(url: URL(string: "http://any-url.com")!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil)
}

func anyHttpUrlResponse(_ code: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: URL(string: "http://any-url.com")!,
                    statusCode: code,
                    httpVersion: nil,
                    headerFields: nil)!
}

func anyError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func anyData() -> Data {
    "any data".data(using: .utf8)!
}

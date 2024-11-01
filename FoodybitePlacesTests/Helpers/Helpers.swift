//
//  Helpers.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

func anyUrlResponse() -> URLResponse {
    URLResponse(url: URL(string: "http://any-url.com")!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil)
}

func anyHttpUrlResponse(code: Int = 200) -> HTTPURLResponse {
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

func randomString(size: Int = 20) -> String {
    let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    return String(Array(0..<size).map { _ in chars.randomElement()! })
}

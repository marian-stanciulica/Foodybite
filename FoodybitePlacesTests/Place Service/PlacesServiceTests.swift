//
//  PlacesServiceTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

final class PlacesServiceTests: XCTestCase {
    
    func makeSUT(response: Decodable) -> (sut: PlacesService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: response)
        let sut = PlacesService(loader: loader)
        return (sut, loader)
    }
    
    func assertURLComponents(
        urlRequest: URLRequest,
        path: String,
        expectedQueryItems: [URLQueryItem],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(urlComponents?.scheme, "https", file: file, line: line)
        XCTAssertNil(urlComponents?.port, file: file, line: line)
        XCTAssertEqual(urlComponents?.host, "maps.googleapis.com", file: file, line: line)
        XCTAssertEqual(urlComponents?.path, path, file: file, line: line)
        XCTAssertEqual(urlComponents?.queryItems, expectedQueryItems, file: file, line: line)
        XCTAssertEqual(urlRequest.httpMethod, "GET", file: file, line: line)
        XCTAssertNil(urlRequest.httpBody, file: file, line: line)
    }
    
}

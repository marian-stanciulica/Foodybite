//
//  PlacesServiceTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Testing
import Foundation
@testable import FoodybitePlaces
import Domain

struct PlacesServiceTests {

    func makeSUT(response: Decodable) -> (sut: PlacesService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: response)
        let sut = PlacesService(loader: loader)
        return (sut, loader)
    }

    func assertURLComponents(
        urlRequest: URLRequest,
        path: String,
        expectedQueryItems: [URLQueryItem],
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)

        #expect(urlComponents?.scheme == "https", sourceLocation: sourceLocation)
        #expect(urlComponents?.port == nil, sourceLocation: sourceLocation)
        #expect(urlComponents?.host == "maps.googleapis.com", sourceLocation: sourceLocation)
        #expect(urlComponents?.path == path, sourceLocation: sourceLocation)
        #expect(urlComponents?.queryItems == expectedQueryItems, sourceLocation: sourceLocation)
        #expect(urlRequest.httpMethod == "GET", sourceLocation: sourceLocation)
        #expect(urlRequest.httpBody == nil, sourceLocation: sourceLocation)
    }

}

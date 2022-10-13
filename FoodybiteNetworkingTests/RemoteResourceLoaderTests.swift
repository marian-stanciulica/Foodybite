//
//  RemoteResourceLoaderTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest

class RemoteResourceLoader {
    let client = HTTPClientSpy()
}

class HTTPClientSpy {
    var urls = [URL]()
}

final class RemoteResourceLoaderTests: XCTestCase {

    func test_init_noRequestTriggered() {
        let sut = RemoteResourceLoader()
        
        XCTAssertEqual(sut.client.urls.count, 0)
    }
    
    
    
}

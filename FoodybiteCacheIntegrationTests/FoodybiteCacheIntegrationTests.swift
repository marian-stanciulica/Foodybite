//
//  FoodybiteCacheIntegrationTests.swift
//  FoodybiteCacheIntegrationTests
//
//  Created by Marian Stanciulica on 06.03.2023.
//

import XCTest
import FoodybitePersistence

final class FoodybiteUserCacheIntegrationTests: XCTestCase {

    func test_loadUser_deliversNilOnEmptyCache() async {
        let userLoader = makeUserLoader()
        
        let user = try? await userLoader.load()
        
        XCTAssertEqual(user, nil)
    }
    
    // MARK: - Helpers
    
    private func makeUserLoader() -> LocalUserLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataUserStore(storeURL: storeURL)
        let sut = LocalUserLoader(store: store)
        return sut
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}

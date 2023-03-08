//
//  GetPlaceDetailsDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

public final class GetPlaceDetailsDAO {
    private let store: LocalStoreReader & LocalStoreWriter

    init(store: LocalStoreReader & LocalStoreWriter) {
        self.store = store
    }
}

final class GetPlaceDetailsDAOTests: XCTestCase {
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetPlaceDetailsDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = GetPlaceDetailsDAO(store: storeSpy)
        return (sut, storeSpy)
    }
    
}

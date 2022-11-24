//
//  PublisherSpy.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Combine

class PublisherSpy<Success> where Success: Equatable {
    private var cancellable: Cancellable?
    private(set) var results = [Success]()
    
    init(_ publisher: AnyPublisher<Success, Never>) {
        cancellable = publisher.sink(receiveValue: { value in
            self.results.append(value)
        })
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

func randomString(size: Int) -> String {
    let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    return String(Array(0..<size).map { _ in chars.randomElement()! })
}
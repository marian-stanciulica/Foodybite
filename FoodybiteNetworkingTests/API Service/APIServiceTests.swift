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
    
    // MARK: - ReviewService Tests
    
    func test_conformsToReviewService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as AddReviewService)
    }
    
    func test_addReview_paramsUsedToCreateEndpoint() async throws {
        let placeID = anyPlaceID()
        let reviewText = anyReviewText()
        let starsNumber = anyStarsNumber()
        let createdAt = Date()
        
        let (sut, _, sender, _) = makeSUT()
        let addReviewEndpoint = ReviewEndpoint.post(AddReviewRequest(placeID: placeID, text: reviewText, stars: starsNumber, createdAt: createdAt))
        let urlRequest = try addReviewEndpoint.createURLRequest()
        
        try await sut.addReview(placeID: placeID, reviewText: reviewText, starsNumber: starsNumber, createdAt: createdAt)
        
        let firstRequest = sender.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_addReview_usesAddReviewEndpointToCreateURLRequest() async throws {
        let placeID = anyPlaceID()
        let reviewText = anyReviewText()
        let starsNumber = anyStarsNumber()
        let createdAt = Date()
        
        let (sut, _, sender, _) = makeSUT()
        let addReviewEndpoint = ReviewEndpoint.post(AddReviewRequest(placeID: placeID, text: reviewText, stars: starsNumber, createdAt: createdAt))
        let urlRequest = try addReviewEndpoint.createURLRequest()
        
        try await sut.addReview(placeID: placeID, reviewText: reviewText, starsNumber: starsNumber, createdAt: createdAt)

        XCTAssertEqual(sender.requests, [urlRequest])
    }
    
    func test_getReviews_usesGetReviewsEndpointToCreateURLRequest() async throws {
        let (sut, loader, _, _) = makeSUT(response: anyGetReviews().response)
        let getReviewsEndpoint = ReviewEndpoint.get(anyPlaceID())
        let urlRequest = try getReviewsEndpoint.createURLRequest()
        
        _ = try await sut.getReviews(placeID: anyPlaceID())

        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_getReviews_returnsExpectedReviews() async throws {
        let (response, expectedModel) = anyGetReviews()
        let (sut, _, _, _) = makeSUT(response: response)
        
        let receivedResponse = try await sut.getReviews()
        
        XCTAssertEqual(expectedModel, receivedResponse)
    }
    
    // MARK: - Helpers
    
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
        method: RequestMethod,
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
    
    private func anyData() -> Data? {
        "any data".data(using: .utf8)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyReviewText() -> String {
        "any review text"
    }
    
    private func anyStarsNumber() -> Int {
        3
    }
    
    private func anyGetReviews() -> (response: [RemoteReview], model: [Review]) {
        let response = [
            RemoteReview(placeID: "place #1", profileImageData: anyData(), authorName: "author #1", reviewText: "review Text #1", rating: 3, createdAt: Date()),
            RemoteReview(placeID: "place #2", profileImageData: anyData(), authorName: "author #2", reviewText: "review Text #2", rating: 1, createdAt: Date()),
            RemoteReview(placeID: "place #3", profileImageData: anyData(), authorName: "author #3", reviewText: "review Text #3", rating: 4, createdAt: Date()),
        ]
        
        let formatter = RelativeDateTimeFormatter()
        let model = response.map {
            Review(id: $0.id,
                   placeID: $0.placeID,
                   profileImageURL: nil,
                   profileImageData: $0.profileImageData,
                   authorName: $0.authorName,
                   reviewText: $0.reviewText,
                   rating: $0.rating,
                   relativeTime: formatter.localizedString(for: $0.createdAt, relativeTo: Date())
            )
        }
        
        return (response, model)
    }

}

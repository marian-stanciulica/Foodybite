//
//  ReviewEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

public enum ReviewEndpoint: Endpoint {
    case addReview(AddReviewRequest)
    
    public var host: String {
        "localhost"
    }
    
    public var path: String {
        "/review"
    }
    
    public var method: RequestMethod {
        .get
    }
    
    public var headers: [String : String] {
        ["Content-Type" : "application/json"]
    }
    
    public var body: Codable? {
        switch self {
        case let .addReview(body):
            return body
        }
    }
}

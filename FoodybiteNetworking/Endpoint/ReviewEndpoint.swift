//
//  ReviewEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

public enum ReviewEndpoint: Endpoint {
    case addReview(AddReviewRequest)
    case getReviews(String?)
    
    public var path: String {
        switch self {
        case .addReview:
            return "/review"
        case let .getReviews(placeID):
            if let placeID = placeID {
                return "/review/\(placeID)"
            }
            
            return "/review"
        }
    }
    
    public var method: RequestMethod {
        switch self {
        case .addReview:
            return .post
        case .getReviews:
            return .get
        }
    }
    
    public var body: Codable? {
        switch self {
        case let .addReview(body):
            return body
        default:
            return nil
        }
    }
}

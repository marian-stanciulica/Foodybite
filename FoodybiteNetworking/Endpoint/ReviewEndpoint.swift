//
//  ReviewEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

public enum ReviewEndpoint: Endpoint {
    case post(AddReviewRequest)
    case get(String?)
    
    public var path: String {
        switch self {
        case .post:
            return "/review"
        case let .get(placeID):
            if let placeID = placeID {
                return "/review/\(placeID)"
            }
            
            return "/review"
        }
    }
    
    public var method: RequestMethod {
        switch self {
        case .post:
            return .post
        case .get:
            return .get
        }
    }
    
    public var body: Codable? {
        switch self {
        case let .post(body):
            return body
        default:
            return nil
        }
    }
}

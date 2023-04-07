//
//  ReviewEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

enum ReviewEndpoint: Endpoint {
    case post(AddReviewRequestBody)
    case get(String?)

    var path: String {
        switch self {
        case .post:
            return "/review"
        case let .get(restaurantID):
            if let restaurantID = restaurantID {
                return "/review/\(restaurantID)"
            }

            return "/review"
        }
    }

    var method: RequestMethod {
        switch self {
        case .post:
            return .post
        case .get:
            return .get
        }
    }

    var body: Encodable? {
        switch self {
        case let .post(body):
            return body
        default:
            return nil
        }
    }
}

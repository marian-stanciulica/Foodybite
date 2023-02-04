//
//  ReviewEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

public enum ReviewEndpoint: Endpoint {
    case addReview
    
    public var host: String {
        "localhost"
    }
    
    var path: String {
        ""
    }
    
    var method: RequestMethod {
        .get
    }
    
    var headers: [String : String] {
        ["Content-Type" : "application/json"]
    }
    
    var body: Codable? {
        nil
    }
}

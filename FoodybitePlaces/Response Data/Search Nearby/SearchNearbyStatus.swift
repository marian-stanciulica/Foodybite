//
//  SearchNearbyStatus.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 15.03.2023.
//

enum SearchNearbyStatus: String, Decodable {
    case ok = "OK"
    case zeroResults = "ZERO_RESULTS"
    case invalidRequest = "INVALID_REQUEST"
    case overQueryLimit = "OVER_QUERY_LIMIT"
    case requestDenied = "REQUEST_DENIED"
    case unknownError = "UNKNOWN_ERROR"
}

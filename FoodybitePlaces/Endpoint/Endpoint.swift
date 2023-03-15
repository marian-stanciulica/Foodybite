//
//  Endpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var host: String {
        "maps.googleapis.com"
    }
    
    private var method: RequestMethod {
        .get
    }
    
    var apiKey: String {
        let bundle = Bundle(for: PlacesService.self)
        guard let filePath = bundle.path(forResource: "GooglePlaces-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'GooglePlaces-Info.plist' containing 'Places API Key'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GooglePlaces-Info.plist'.")
        }
        
        return value
    }
    
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else { throw  NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

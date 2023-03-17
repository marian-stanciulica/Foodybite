//
//  Endpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import SharedAPI

public extension Endpoint {
    var scheme: String {
        "https"
    }
    
    var port: Int? {
        nil
    }
    
    var host: String {
        "maps.googleapis.com"
    }
    
    var method: RequestMethod {
        .get
    }
    
    var body: Encodable? {
        nil
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
}

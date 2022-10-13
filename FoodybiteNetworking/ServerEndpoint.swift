//
//  ServerEndpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

enum ServerEndpoint: Endpoint {
    case signup(name: String, email: String, password: String, confirmPassword: String)
    case login(email: String, password: String)
    
    var host: String {
        "localhost"
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/auth/signup"
        case .login:
            return "/auth/login"
        }
    }
    
    var method: RequestMethod {
        .post
    }
    
    var headers: [String : String] {
        ["Content-Type" : "application/json"]
    }
    
    var body: [String : String] {
        var body = [String : String]()
        
        switch self {
        case let .signup(name, email, password, confirmPassword):
            body["name"] = name
            body["email"] = email
            body["password"] = password
            body["confirm_password"] = confirmPassword
        case let .login(email, password):
            body["email"] = email
            body["password"] = password
        }
        
        return body
    }
    
    var urlParams: [String : String] {
        [:]
    }
}

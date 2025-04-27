//
//  Router.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import Foundation
import UIKit

protocol Routable {
    var method: HTTPMethod { get }
    var entryPoint: String { get }
    var param: [String: Any]? { get }
    var urlRequest: URLRequest { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Router: Routable {
    case login(email: String, password: String)
    case userList(RequestModel.UserList)
}

extension Router {
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    var entryPoint: String {
        switch self {
        case .login:
            return "/Platform/App/GetAccessToken"
        case .userList:
            return "/users"
        }
    }
    var param: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .userList(let model):
            return model.dictionary
        default:
            return nil
        }
    }
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = mainHost
        urlComponents.path = entryPoint
        
        guard var url = urlComponents.url else {
            fatalError("❌ URL 생성 실패: \(urlComponents)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

//
//  EndpointProtocol.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import Foundation

protocol EndpointProtocol: AnyObject {
    var urlBase: String { get set }
    var path: String { get set }
    var httpMethod: HTTPMethod { get set }
    var body: Data { get set }
    var headers: [String: String] { get set }
    var queries: [URLQueryItem] { get set }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension EndpointProtocol {
    func makeURL() -> URL? {
        guard var component = URLComponents(string: "\(urlBase)\(path)") else { return nil }
        component.scheme = "https"
        component.queryItems = queries.isEmpty ? nil : queries
        return component.url
    }

    func getBasicAuth() -> String? {
        guard
            let user = Bundle.main.object(forInfoDictionaryKey: "API_USER"),
            let password = Bundle.main.object(forInfoDictionaryKey: "API_PASSWORD")
        else { return nil }

        guard let authString = "\(user):\(password)"
            .data(using: .utf8)?
            .base64EncodedString()
        else { return nil }

        return "Basic \(authString)"
    }

    func makeRequest() throws -> URLRequest {
        guard let url = self.makeURL() else {
            throw APICallError.invalidUrl
        }

//        guard let auth = self.getBasicAuth() else {
//            throw APICallError.invalidAuth
//        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.headers
        request.httpMethod = self.httpMethod.rawValue
//        request.addValue(auth, forHTTPHeaderField: "Authorization")

        return request
    }
}

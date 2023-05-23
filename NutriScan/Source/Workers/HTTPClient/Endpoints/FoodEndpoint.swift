//
//  FoodEndpoint.swift
//  NutriScan
//
//  Created by Yago Marques on 12/05/23.
//

import Foundation

class FoodListEndpoint: EndpointProtocol {
    var urlBase: String = "nutrivision.up.railway.app"
    var path: String = "/deliveredUi"
    var httpMethod: HTTPMethod
    var body: Data
    var headers: [String : String]
    var queries: [URLQueryItem]

    init(
        httpMethod: HTTPMethod = .get,
        body: Data = Data(),
        headers: [String: String] = ["Content-Type": "application/json"],
        queries: [URLQueryItem] = []
    ) {
        self.httpMethod = httpMethod
        self.body = body
        self.headers = headers
        self.queries = queries
    }
}

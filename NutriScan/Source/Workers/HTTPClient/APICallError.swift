//
//  APICallError.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import Foundation

enum APICallError: Error {
    case invalidUrl
    case network(Error)
    case invalidAuth
    case invalidResponse
    case httpError(code: Int)
}

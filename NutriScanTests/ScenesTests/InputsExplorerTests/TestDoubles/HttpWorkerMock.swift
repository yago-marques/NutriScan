//
//  HttpWorkerMock.swift
//  NutriScanTests
//
//  Created by Yago Marques on 22/05/23.
//

import Foundation
@testable import NutriScan

enum HTTPWorkerMode {
    case asyncAwait, completionHandler
}

final class HttpWorkerMock: HTTPClient {
    private let remoteResult = InputsExplorerConstants.mockedRemoteFoodResults()
    var internetIsOn = true
    var endpointFlag: (method: String, path: String, mode: HTTPWorkerMode)? = nil

    func request(endpoint: NutriScan.EndpointProtocol, completion: @escaping (Result<Data, NutriScan.APICallError>) -> Void) {
        endpointFlag = (endpoint.httpMethod.rawValue, endpoint.path, mode: .completionHandler)
        completion(.success(remoteResult))
    }

    func request(endpoint: NutriScan.EndpointProtocol) async throws -> Data? {
        endpointFlag = (endpoint.httpMethod.rawValue, endpoint.path, mode: .asyncAwait)
        return internetIsOn ? remoteResult : nil
    }
}

//
//  URLSessionHTTPClient.swift
//  NutriScan
//
//  Created by Yago Marques on 06/05/23.
//

import Foundation

protocol HTTPClient {
    func request(endpoint: EndpointProtocol, completion: @escaping (Result<Data, APICallError>) -> Void)
    func request(endpoint: EndpointProtocol) async throws -> Data?
}

final class URLSessionHTTPClient: HTTPClient {

    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func request(endpoint: EndpointProtocol, completion: @escaping (Result<Data, APICallError>) -> Void) {
        do {
            let request = try endpoint.makeRequest()

            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.network(error)))
                }

                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.invalidUrl))
                    return
                }

                switch response.statusCode {
                case 200...300:
                    if let data = data {
                        completion(.success(data))
                    }
                default:
                    completion(.failure(.httpError(code: response.statusCode)))
                }
            }

            task.resume()
        } catch {
            completion(.failure(error as! APICallError))
        }
    }

    func request(endpoint: EndpointProtocol) async throws -> Data? {
        do {
            let request = try endpoint.makeRequest()

            let (data, response) = try await session.data(for: request)

            guard let response = response as? HTTPURLResponse else { return nil }
            switch response.statusCode {
            case 200...300:
                return data
            default:
                return nil
            }
        } catch {
            throw error
        }
    }
}

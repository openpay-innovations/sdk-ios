//
//  APIService.swift
//  Example
//
//  Created by june chen on 12/2/21.
//  Copyright © 2021 Openpay. All rights reserved.
//

import Foundation

protocol APIService {
    typealias Completion = (Result<Data, Error>) -> Void
    func request(_ endpoint: Endpoint, completion: @escaping APIService.Completion)
}

struct HTTPSAPIService: APIService {

    private let urlSession: URLSession
    private let baseURL: URL

    init(baseURL: URL, urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }

    func request(_ endpoint: Endpoint, completion: @escaping APIService.Completion) {
        let request = makeRequest(endpoint, baseURL: baseURL)

        urlSession.dataTask(with: request) { data, _, error in
          if let data = data, error == nil {
            completion(.success(data))
          } else {
            completion(.failure(error ?? NetworkError.unknown))
          }
        }
        .resume()
    }

    private func makeRequest(_ endpoint: Endpoint, baseURL: URL) -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint.path)
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = endpoint.method

        urlRequest.httpBody = endpoint.body
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }
}

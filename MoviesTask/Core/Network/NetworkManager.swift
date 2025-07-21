//
//  Network.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import Foundation
import Alamofire
import Combine

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        let url = APIConstants.baseURL + endpoint.path
        let headers: HTTPHeaders = [
            "Authorization": APIConstants.bearerToken,
            "accept": "application/json"
        ]

        return AF.request(url,
                          method: endpoint.method,
                          parameters: endpoint.parameters,
                          headers: headers)
            .validate()
            .publishDecodable(type: T.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}



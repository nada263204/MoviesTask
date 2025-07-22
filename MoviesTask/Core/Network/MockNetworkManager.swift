//
//  MockNetworkManager.swift
//  MoviesTaskTests
//
//  Created by Macos on 23/07/2025.
//

import Foundation
import Combine

class MockNetworkManager: NetworkManaging {
    var result: Result<Data, Error>?

    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let result = result else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }

        switch result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return Just(decoded)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }

        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

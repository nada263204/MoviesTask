//
//  APIServices.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import Foundation
import Alamofire
import Combine

class MovieAPIService {
    static let shared = MovieAPIService()

    func fetchTopMovies(year: Int = 2025) -> AnyPublisher<[Movie], Error> {
        NetworkManager.shared
            .request(.topMovies(year: year), responseType: MovieResponse.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        NetworkManager.shared
            .request(.popularMovies, responseType: MovieResponse.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }

}


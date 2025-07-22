//
//  Endpoints.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import Foundation
import Alamofire

enum APIEndpoint {
    case topMovies(year: Int)
    case popularMovies
    
    var path: String {
        switch self {
        case .topMovies:
            return "/discover/movie"
        case .popularMovies:
            return "/movie/popular"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters {
        switch self {
        case .topMovies(let year):
            return [
                "sort_by": "popularity.desc",
                "primary_release_year": year,
                "language": "en-US",
                "include_adult": false,
                "page": 1
            ]
        case .popularMovies:
            return [
                "language": "en-US",
                "page": 1
            ]
        }
    }
}



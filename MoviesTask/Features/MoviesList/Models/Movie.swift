//
//  Movie.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let rating: Double
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

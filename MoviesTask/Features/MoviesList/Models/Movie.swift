//
//  Movie.swift
//  MoviesTask
//
//  Created by Macos on 21/07/2025.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let releaseDate: String
    let overview: String
    let rating: Double
    let voteCount: Int
    let posterPath: String
    let backdropPath: String
    let genreIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case releaseDate = "release_date"
        case overview
        case rating = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}


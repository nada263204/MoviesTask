//
//  MovieStorageManager.swift
//  MoviesTask
//
//  Created by Macos on 22/07/2025.
//

import Foundation

class MovieStorageManager {
    static let shared = MovieStorageManager()
    private init() {}

    private func fileURL(for fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }

    func saveMovies(_ movies: [Movie], to fileName: String) {
        let url = fileURL(for: fileName)
        do {
            let data = try JSONEncoder().encode(movies)
            try data.write(to: url)
        } catch {
            print("Error: \(error)")
        }
    }

    func loadMovies(from fileName: String) -> [Movie] {
        let url = fileURL(for: fileName)
        do {
            let data = try Data(contentsOf: url)
            let movies = try JSONDecoder().decode([Movie].self, from: data)
            return movies
        } catch {
            print("No saved movies found or decode failed: \(error)")
            return []
        }
    }
}

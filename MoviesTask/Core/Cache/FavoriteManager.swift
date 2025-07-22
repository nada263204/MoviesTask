//
//  FavoriteManager.swift
//  MoviesTask
//
//  Created by Macos on 22/07/2025.
//

import Foundation

class FavoritesManager {
    
    static let shared = FavoritesManager()
    
    private let favoritesKey = "favoriteMovies"
    
    private init() {}

    func addToFavorites(movie: Movie) {
        var movies = getFavoriteMovies()
        guard !movies.contains(where: { $0.id == movie.id }) else { return }
        movies.append(movie)
        saveFavoriteMovies(movies)
    }
    
    func removeFromFavorites(movie: Movie) {
        var movies = getFavoriteMovies()
        movies.removeAll { $0.id == movie.id }
        saveFavoriteMovies(movies)
    }
    
    func isFavorite(id: Int) -> Bool {
        return getFavoriteMovies().contains(where: { $0.id == id })
    }
    
    func getFavoriteMovies() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        return (try? JSONDecoder().decode([Movie].self, from: data)) ?? []
    }
    
    func clearAllFavorites() {
        UserDefaults.standard.removeObject(forKey: favoritesKey)
    }
    
    private func saveFavoriteMovies(_ movies: [Movie]) {
        if let data = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}

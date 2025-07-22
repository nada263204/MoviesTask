//
//  FavoriteViewModel.swift
//  MoviesTask
//
//  Created by Macos on 22/07/2025.
//

import Foundation

class FavoriteViewModel {
    
    private let favoritesManager = FavoritesManager.shared
    
    func getFavoriteMovies() -> [Movie] {
        return favoritesManager.getFavoriteMovies()
    }
    
    func addToFavorites(movie: Movie) {
        favoritesManager.addToFavorites(movie: movie)
    }
    
    func removeFromFavorites(movie: Movie) {
        favoritesManager.removeFromFavorites(movie: movie)
    }
    
    func isFavorite(movie: Movie) -> Bool {
        return favoritesManager.isFavorite(id: movie.id)
    }
    
    func toggleFavorite(movie: Movie) {
        if isFavorite(movie: movie) {
            removeFromFavorites(movie: movie)
        } else {
            addToFavorites(movie: movie)
        }
    }
}

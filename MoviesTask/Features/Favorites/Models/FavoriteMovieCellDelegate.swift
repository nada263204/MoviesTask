//
//  FavoriteMovieCellDelegate.swift
//  MoviesTask
//
//  Created by Macos on 22/07/2025.
//

import Foundation

protocol FavoriteMovieCellDelegate: AnyObject {
    func didRequestRemoveFavorite(_ movie: Movie)
}
